class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authorize

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
   return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    article = Article.find(params[:id])
    render json: article
  end

  private
  
  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

# return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
#   document = Document.find(params[:id])
#   render json: document