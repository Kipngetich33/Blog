class ArticleMailer < ApplicationMailer

    def new_article_mailer(user)
        @user = user
        mail to: user.email, subject: "Artcle created successfully", from: 'khalifngeno@gmail.com'
    end
    
end