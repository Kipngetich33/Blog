# require Pony

# using SendGrid's Ruby Library
# https://github.com/sendgrid/sendgrid-ruby
# require 'sendgrid-ruby'
# include SendGrid

class Article < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10}

    after_create :new_article_notification
    
    def new_article_notification
        '''
        Add functionality to send an email notifications to the creator of the article
        '''
        # send_mails_with_pony()
        # send_mail_with_sendgrid()
        
    end
end


def send_mail_with_sendgrid
    '''
    Function meant to test sending of emails with SendGrid
    '''
    begin
        from = SendGrid::Email.new(email: 'khalifngeno@gmail.com')
        to = SendGrid::Email.new(email: 'kipngetich.ngeno333@gmail.com')
        subject = 'Sending with SendGrid is Fun'
        content = SendGrid::Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
        mail = SendGrid::Mail.new(from, subject, to, content)

        sg = SendGrid::API.new(api_key: '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' )
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts response.status_code
        puts response.body
        puts response.headers
    rescue 
        puts("*"*80)
        puts("An error occured while sending email.")
    end
end

def send_mails_with_pony
    '''
    Test function meant to check how the pony gem works
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