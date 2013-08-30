# Delayed_job SQS backend

This is an [SQS](http://aws.amazon.com/sqs/) backend for [delayed_job](http://github.com/collectiveidea/delayed_job)

This is just a rough starting point for using SQS as a job queue for DJ. I recommend you vendor these files and adjust them to suit your needs

# Getting Started

## Installation

Add the gems to your `Gemfile:`

```ruby
gem 'delayed_job'
gem 'dj_sqs'
```

## Usage

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).

Example:

```ruby
class User
  def background_stuff
    puts "I run in the background"
  end
end
```

Then in one of your controllers:

```ruby
user = User.new
user.delay.background_stuff
```

## Start worker process

    rake jobs:work

That will start pulling jobs off the queue and processing them.

## License

MIT: http://neutroncreations.mit-license.org/2008
