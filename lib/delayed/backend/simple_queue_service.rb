module Delayed
  module Backend
    module SimpleQueueService
      class Job
        include Delayed::Backend::Base
        attr_accessor :handler

        def initialize data = {}

          if data.is_a? AWS::SQS::ReceivedMessage
            @sqs_message = data
            data = MultiJson.load(@sqs_message.body)
          end

          # print data.to_yaml + "\n\n"

          data.symbolize_keys!
          payload_obj = data.delete(:payload_object) || data.delete(:handler)

          @attributes = data
          self.payload_object = payload_obj

        end

        def id
          @sqs_message.id
        end

        def payload_object=(object)
          if object.is_a? String
            @payload_object = YAML.load(object)
            self.handler = object
          else
            @payload_object = object
            self.handler = object.to_yaml
          end
        end

        def save

          payload = MultiJson.dump(@attributes.merge(:payload_object => YAML.dump(payload_object)))

          #puts "[SAVE] #{payload.inspect}"

          @sqs_message.delete if @sqs_message

          Delayed::Worker.sqs.send_message payload, :delay_seconds => [900,(attempts**3)].min

          true
        end

        def save!
          save
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

        def last_error= error
          @attributes[:last_error] = error
        end

        def attempts
          @attributes[:attempts] || 0
        end
        def attempts= num
          @attributes[:attempts] = num
        end

        def run_at= ts
          @attributes[:run_at] = ts
        end

        def destroy
          @sqs_message.delete if @sqs_message
        end




        # No need to check locks
        def self.clear_locks!(*args)
          true
        end

        def self.db_time_now
          Time.now.utc
        end

        def self.find_available worker_name, limit = 5, max_run_time = nil
          messages = Delayed::Worker.sqs.receive_message :limit => limit, :wait_time_seconds => 20
          objects = []
          if messages
            messages = [messages] unless messages.is_a? Array
            messages.each do |m|
              objects << Delayed::Backend::SimpleQueueService::Job.new(m)
            end
          end
          # print '.'
          objects
        end
      end
    end
  end
end
