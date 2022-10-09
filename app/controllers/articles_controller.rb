class ArticlesController < ApplicationController
  # protect certain routes based on authorization
  skip_before_action :authenticate_user!, :only => [:index,:show] do
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
  end

  def create
    puts("*"*80)
    puts('Running the new controller')
    @article = Article.new(article_params) 

    if @article.save()
      redirect_to @article
      # send an email to the creater here
      puts("after redirection")
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
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy()

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
