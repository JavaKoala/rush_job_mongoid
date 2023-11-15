require_relative "lib/rush_job_mongoid/version"

Gem::Specification.new do |spec|
  spec.name        = "rush_job_mongoid"
  spec.version     = RushJobMongoid::VERSION
  spec.authors     = ["JavaKoala"]
  spec.email       = ["javakoala1@gmail.com"]
  spec.homepage    = "https://github.com/JavaKoala/rush_job_mongo_id"
  spec.summary     = "User interface for delayed_job with MongoDB"
  spec.description = "Rails web interface for delayed_job using Rails::Engine and MongoDB"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/JavaKoala/rush_job_mongo_id"
  spec.metadata["changelog_uri"] = "https://github.com/JavaKoala/rush_job_mongo_id"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency 'actionview', '~> 7.0'
  spec.add_dependency 'activerecord', '~> 7.0'
  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_dependency 'importmap-rails', '~> 1.2'
  spec.add_dependency 'pagy', '~> 6.0'
  spec.add_dependency 'sassc-rails', '~> 2.1'

  spec.add_runtime_dependency 'delayed_job', '~> 4.1'
  spec.add_runtime_dependency 'delayed_job_mongoid', '~> 3.0'
end
