class Article < ApplicationRecord
    # link the events child table to Article
    has_many :events

    # add model validators for fields
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10}

    #controller for after article creation
    after_create :new_article_notification
    
    def new_article_notification
        '''
        Add functionality to send an email notifications to the creator of the article
        '''
        puts('New artile ................................................')
        # define sender & recipient emails
        sender_email = "khalifngeno@gmail.com"
        recipient_email = self.creator

        # get assiociated user id
        blog_creator = User.find_by({:email => self.creator})
        # create an event_id as event_type_article_id_user_id (event this is New_Article)
        event_id = "New_Article-#{self.id}-#{blog_creator.id}"

        puts("Event Id:#{event_id}......................................")
        # call functionality to send emails with sendgrid
        send_mail_with_sendgrid(event_id,sender_email,recipient_email)        
    end
end


def send_mail_with_sendgrid(event_id,sender_email,recipient_email)
    '''
    Function meant to test sending of emails with SendGrid
    '''
    puts("Sending .....................")
    # create an instance of SendGrid
    sendgrid_mail = SendGrid

    begin
        puts("Attempting...................................")
        # create and send you email
        from = sendgrid_mail::Email.new(email: sender_email)
        to = sendgrid_mail::Email.new(email: recipient_email)
        subject = 'New Article'
        content = sendgrid_mail::Content.new(type: 'text/plain', value: 'You have successfully created a new article.')
        mail = sendgrid_mail::Mail.new(from, subject, to, content)
        # add you custom arguments here
        # mail.add_custom_arg(CustomArg.new(key: 'event_id', value: event_id))
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts("Done ..............................................................")
    rescue 
        # run this block if there is a failure while sending the email
        puts("*"*80)
        puts("An error occured while sending you email.")
        
        return {
            :status => false,
            :message => "An error occured while sending you email."
        }
    end
end
