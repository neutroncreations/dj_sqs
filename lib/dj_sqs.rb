# encoding: utf-8
require 'fog'
require 'multi_json'
require 'delayed_job'

require_relative 'delayed/backend/simple_queue_service'

Delayed::Worker.backend = :simple_queue_service
