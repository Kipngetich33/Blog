class EventsController < ApplicationController
    skip_before_action :authenticate_user!, :only => [:email_event ] do
        redirect_to new_user_session_path unless current_user
    end

    def create
        @article = Article.find(params[:article_id])
        @event = @article.events.create(event_params)
        # redirect_to article_path(@article)
        redirect_to root_path
    end

    def email_event 
        # get parameters from sendgrid
        begin        
            # loop through each events in the return events list
            for events_key in params["_json"]
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
                # save the event to the correct article
                @article = Article.find(2)
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

    def events_dashboard
        @return_hash = {}
        # pull all the events in the system
        @events = Event.all()
        # collect emails with same event id
        for event in @events
            # check if event in in return hash
            unless @return_hash.include?(event.event_id)
                puts("Adding even id")
                @return_hash[event.event_id] = { :processed => false, :delivered => false,
                        :email => event.email,
                    }
            end
            # Mark the different statuses
            if event.event == "processed"
                @return_hash[event.event_id][:processed] = true
            elsif event.event == "delivered"
                @return_hash[event.event_id][:delivered] = true
            else
                # just pass for now
            end

        end
        # puts("final")
        # puts(@return_hash)
        # aggregated_hash = @return_hash.each{|k,v| return_hash[k]=v}
        # puts(aggregated_hash)
    end
    
    private
        def event_params
          params.require(:email).permit(:email, :event, :ip, :response, :sg_message_id,
          :sg_event_id,:smtp_id,:timestamp,:tls, :sendgridtime )
        end
end
