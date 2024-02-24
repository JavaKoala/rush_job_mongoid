import { Application } from '@hotwired/stimulus';
import RushJobMongoidPollingController from './controllers/rush_job_mongoid_polling_controller';
import RushJobMongoidTableUpdateController from './controllers/rush_job_mongoid_table_update_controller';
import 'bootstrap';

window.Stimulus = Application.start();
Stimulus.register('rush-job-mongoid-polling', RushJobMongoidPollingController);
Stimulus.register('rush-job-mongoid-table-update', RushJobMongoidTableUpdateController);
