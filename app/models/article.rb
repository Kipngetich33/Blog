# require Pony

class Article < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10}

    after_create :new_article_notification
    
    def new_article_notification
        '''
        Add functionality to send an email notifications to the creator of the article
        '''
        Pony.mail({
            :to => self.creator,
            :subject => "Test Mail",
            # :body => 'This is a test mails',
            :html_body => "<h2>Article published!</h2>
            <p>Hello writer your article titled: #{self.title} has been published successfully.</p>
            <p> From: Jarida Leo </p>
            ",
            :via => :smtp,
            :via_options => {
                :address              => 'smtp.gmail.com',
                :port                 => '587',
                :enable_starttls_auto => true,
                :user_name            => 'khalifngeno@gmail.com',
                :password             => 'trrfapyjnauwmehc',
                :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
            }
        })
    end
end
