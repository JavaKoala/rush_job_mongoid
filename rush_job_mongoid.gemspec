require_relative 'lib/rush_job_mongoid/version'

Gem::Specification.new do |spec|
  spec.name        = 'rush_job_mongoid'
  spec.version     = RushJobMongoid::VERSION
  spec.authors     = ['JavaKoala']
  spec.email       = ['javakoala1@gmail.com']
  spec.homepage    = 'https://github.com/JavaKoala/rush_job_mongo_id'
  spec.summary     = 'User interface for delayed_job with MongoDB'
  spec.description = 'Rails web interface for delayed_job using Rails::Engine and MongoDB'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JavaKoala/rush_job_mongo_id'
  spec.metadata['changelog_uri'] = 'https://github.com/JavaKoala/rush_job_mongo_id'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'actionview', '~> 7.0'
  spec.add_dependency 'activerecord', '~> 7.0'
  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_dependency 'importmap-rails', '~> 1.2'
  spec.add_dependency 'mongoid', '~> 8.1'
  spec.add_dependency 'pagy', '~> 6.0'
  spec.add_dependency 'sassc-rails', '~> 2.1'

  spec.add_runtime_dependency 'delayed_job', '~> 4.1'
  spec.add_runtime_dependency 'delayed_job_mongoid', '~> 3.0'

  spec.add_development_dependency 'brakeman', '~> 6.0'
  spec.add_development_dependency 'debug', '~> 1.8'
  spec.add_development_dependency 'puma', '~> 6.3'
  spec.add_development_dependency 'rubocop-capybara', '~> 2.18'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.31.0'
  spec.add_development_dependency 'rubocop-rails', '~> 2.21'
  spec.add_development_dependency 'sprockets-rails', '~> 3.4'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
