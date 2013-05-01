# encoding: utf-8
require 'aws-sdk'
require 'multi_json'
require 'delayed_job'

require_relative 'delayed/backend/config'
require_relative 'delayed/backend/simple_queue_service'
require_relative 'delayed/backend/worker'

Delayed::Worker.backend = :simple_queue_service
