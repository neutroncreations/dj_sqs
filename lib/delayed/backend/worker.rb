module Delayed
  class Worker
    class << self
      def configure
        yield(config)
        @sqs = AWS::SQS.new(
          :access_key_id => config.aws_access_key_id,
          :secret_access_key => config.aws_secret_access_key,
          :region => config.region
        ).queues[config.queue_url]
      end

      def config
        @config ||= SqsConfig.new
      end

      def sqs
        @sqs
      end

    end
  end
end
