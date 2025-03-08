module RushJobMongoid
  require 'importmap-rails'
  require 'mongoid'
  require 'propshaft'

  class Engine < ::Rails::Engine
    isolate_namespace RushJobMongoid

    initializer 'rush_job_mongoid.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << root.join('config/importmap.rb')
      app.config.importmap.cache_sweepers << root.join('app/assets/javascript')
    end

    initializer 'rush_job_mongoid.assets.precompile' do |app|
      app.config.assets.precompile += %w[
        rush_job_mongoid/application.css
        rush_job_mongoid/application.scss
        rush_job_mongoid/application.js
        rush_job_mongoid_manifest.js
      ]
    end
  end
end
