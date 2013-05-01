Gem::Specification.new do |gem|
  gem.name          = 'dj_sqs'
  gem.version       = '1.0.0'
  gem.date          = '2013-04-30'
  gem.summary       = "DelayedJob SQS"
  gem.description   = "A SQS delayed job backend"
  gem.authors       = ["Marc Roberts"]
  gem.email         = 'marc@neutroncreations.com'
  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ['lib']
  gem.homepage      = 'https://github.com/neutroncreations/dj_sqs'
  gem.add_dependency(%q<delayed_job>, ["~> 3.0.0"])
  gem.add_dependency(%q<aws-sdk>, ["~> 1.0"])
  gem.add_dependency(%q<multi_json>, ["~> 1.7"])
end