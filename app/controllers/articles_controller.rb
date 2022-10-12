class ArticlesController < ApplicationController
  # protect certain routes based on authorization
  skip_before_action :authenticate_user!, :only => [:index,:show,:email_event ] do
    redirect_to new_user_session_path unless current_user
  end

  def index
    @articles = Article.all()
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new()
    # @article = Article.new(title: "...", body: "...")
  end

  def create
    @article = Article.new(article_params) 
    # add the creator email here
    @article.creator = current_user.email

    if @article.save()
      redirect_to @article, alert:"Article Created Successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # puts(current_user.admin)
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article, alert:"Article Updated Successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy()

    redirect_to root_path, status: :see_other, alert:"Article Deleted Successfully"
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :creator)
    end
end
