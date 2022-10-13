class Api::V1::EventsController < ApplicationController
    
    skip_before_action :authenticate_user!, :only => [:email_event ] do
        redirect_to new_user_session_path unless current_user
    end

    def email_event
        # get parameters from sendgrid
        begin 
            # loop through each events in the return events list
            for events_key in params["_json"]
               puts("looping through")

                current_id = events_key['event_id']
                if current_id
                    event_id = current_id
                else
                    event_id = "N/A"
                end

                puts("event id")
                puts(event_id)
                
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
                    :event_id => event_id
                }

                if event_id != "N/A"
                    puts("attempting save.............................")
                    # save the event to the correct article
                    artile_id = (events_key['event_id'].split("-")[1]).to_i
                    @article = Article.find(artile_id)
                    @article.events.create(event_params)
                end
            end
        rescue
            print("Error occured while saving email event to database................................................")
            return render json: { 
                :event_recieved => false, 
                :message => "Error occured while saving email event to database"
            }
        end
    
        return  render json:{
          :event_recieved => true
        }
    end
end
