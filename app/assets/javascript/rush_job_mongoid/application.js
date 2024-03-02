import { Application } from '@hotwired/stimulus';
import Rails from '@rails/ujs';
import RushJobMongoidPollingController from './controllers/rush_job_mongoid_polling_controller';
import RushJobMongoidReloadJobsTableController from './controllers/rush_job_mongoid_reload_jobs_table_controller';
import 'bootstrap';

Rails.start();

window.Stimulus = Application.start();
Stimulus.register('rush-job-mongoid-polling', RushJobMongoidPollingController);
Stimulus.register('rush-job-mongoid-reload-jobs-table', RushJobMongoidReloadJobsTableController);
