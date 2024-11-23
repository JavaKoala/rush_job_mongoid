require_relative 'lib/rush_job_mongoid/version'

Gem::Specification.new do |spec|
  spec.name        = 'rush_job_mongoid'
  spec.version     = RushJobMongoid::VERSION
  spec.authors     = ['JavaKoala']
  spec.email       = ['javakoala1@gmail.com']
  spec.homepage    = 'https://github.com/JavaKoala/rush_job_mongoid'
  spec.summary     = 'User interface for delayed_job with MongoDB'
  spec.description = 'Rails web interface for delayed_job using Rails::Engine and MongoDB'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JavaKoala/rush_job_mongoid'
  spec.metadata['changelog_uri'] = 'https://github.com/JavaKoala/rush_job_mongoid'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'actionview', '~> 8.0'
  spec.add_dependency 'activesupport', '~> 8.0'
  spec.add_dependency 'delayed_job', '~> 4.1'
  spec.add_dependency 'delayed_job_mongoid', '~> 3.0'
  spec.add_dependency 'importmap-rails', '~> 2.0'
  spec.add_dependency 'mongoid', '~> 9.0'
  spec.add_dependency 'sassc-rails', '~> 2.1'
  spec.add_dependency 'turbo-rails', '~> 2.0'

  spec.add_development_dependency 'brakeman', '~> 6.2'
  spec.add_development_dependency 'capybara', '~> 3.40'
  spec.add_development_dependency 'database_cleaner-mongoid', '~> 2.0'
  spec.add_development_dependency 'debug', '~> 1.9'
  spec.add_development_dependency 'puma', '~> 6.4'
  spec.add_development_dependency 'rubocop-capybara', '~> 2.21'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.36.0'
  spec.add_development_dependency 'rubocop-rails', '~> 2.27'
  spec.add_development_dependency 'selenium-webdriver', '~> 4.26'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'sprockets-rails', '~> 3.5'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
