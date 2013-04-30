module Delayed
  class Worker
    class << self
      def configure
        yield(config)
        @sqs = Fog::AWS::SQS.new(
          :aws_access_key_id => config.aws_access_key_id,
          :aws_secret_access_key => config.aws_secret_access_key,
          :region => config.region
        )
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
