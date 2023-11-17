module RushJobMongoid
  class Engine < ::Rails::Engine
    isolate_namespace RushJobMongoid

    initializer 'rush_job.assets.precompile' do |app|
      app.config.assets.precompile += %w[
        rush_job_mongoid/application.css
      ]
    end
  end
end
