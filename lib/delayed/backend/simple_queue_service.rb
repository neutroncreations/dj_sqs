module Delayed
  module Backend
    module SimpleQueueService
      class Job
        include Delayed::Backend::Base
        attr_accessor :handler

        def initialize data = {}
          print data.to_yaml

          data.symbolize_keys!
          payload_obj = data.delete(:payload_object) || data.delete(:handler)

          @attributes = data
          self.payload_object = payload_obj

          @sqs = Fog::AWS::SQS.new(
            :aws_access_key_id => ENV['AWS_SQS_KEY'],
            :aws_secret_access_key => ENV['AWS_SQS_SECRET'],
            :region => ENV['AWS_SQS_REGION']
          )
          @queue_url = ENV['AWS_SQS_URL']

        end

        def save

          payload = MultiJson.dump(@attributes.merge(:payload_object => YAML.dump(payload_object)))

          puts "[SAVE] #{payload.inspect}"

          @sqs.send_message(@queue_url, payload)

          true
        end

        def save!
          save
        end

        def find_available
          
        end

        def update_attributes(attributes)
          attributes.symbolize_keys!
          @attributes.merge attributes
          save
        end

        # No need to check locks
        def lock_exclusively!(*args)
          true
        end

        # No need to check locks
        def unlock(*args)
          true
        end

        def reload(*args)
          # reset
          super
        end



        
        # No need to check locks
        def clear_locks!(*args)
          true
        end
      end
    end
  end
end
