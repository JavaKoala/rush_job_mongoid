import { Application } from '@hotwired/stimulus';
import RushJobMongoidConfirmController from './controllers/rush_job_mongoid_confirm_controller';
import RushJobMongoidFiltersController from './controllers/rush_job_mongoid_filters_controller';
import RushJobMongoidPollingController from './controllers/rush_job_mongoid_polling_controller';
import RushJobMongoidReloadJobsTableController from './controllers/rush_job_mongoid_reload_jobs_table_controller';
import 'bootstrap';
import '@hotwired/turbo-rails';

window.Stimulus = Application.start();
Stimulus.register('rush-job-mongoid-confirm', RushJobMongoidConfirmController);
Stimulus.register('rush-job-mongoid-filter', RushJobMongoidFiltersController);
Stimulus.register('rush-job-mongoid-polling', RushJobMongoidPollingController);
Stimulus.register('rush-job-mongoid-reload-jobs-table', RushJobMongoidReloadJobsTableController);
