class EventsController < ApplicationController
    skip_before_action :authenticate_user!, :only => [:email_event ] do
        redirect_to new_user_session_path unless current_user
    end

    def create
        print("Contoller reached")
        @article = Article.find(params[:article_id])
        @event = @article.events.create(event_params)
        puts("Successfulu save")
        # redirect_to article_path(@article)
        redirect_to root_path
    end

    def email_event
        #add logic here
        puts("*"*80)
        puts("Runnign a post event")
        puts(params)
    
        # get parameters from sendgrid
        begin
            print("attempting")
        
            # loop through each events in the return events list
            for events_key in params["_json"]
                puts "looping though"
                puts(events_key['timestamp'])
                # create hash/dictonary for event parameters
                event_params = {
                    :email => events_key['email'], 
                    :event => events_key['event'], 
                    :ip => events_key['ip'],
                    :response => events_key['response'],
                    :sg_event_id => events_key['sg_event_id'],
                    :sg_message_id => events_key['sg_message_id'],
                    :smtp_id => events_key['smtp-id'],
                    # :sendgridtime => events_key['timestamp'], adding timestamp cause the saving to fails
                    :tls => events_key['tls'],
                }
                puts "Event parameters"
                puts event_params
                # save the event to the correct article
                @article = Article.find(2)
                puts("article")
                print(@article)
                @article.events.create(event_params)
            end
        rescue
    
          return render json: { 
            :event_recieved => false, 
            :message => "Error occured while saving email event to database"
          }
    
        end
    
        return  render json:{
          :event_recieved => true
        }
    end
    
    private
        def event_params
          params.require(:email).permit(:email, :event, :ip, :response, :sg_message_id,
          :sg_event_id,:smtp_id,:timestamp,:tls, :sendgridtime )
          
        end
end
