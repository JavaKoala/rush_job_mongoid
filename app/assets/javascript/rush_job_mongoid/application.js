import { Application } from '@hotwired/stimulus';
import RushJobMongoidPollingController from './controllers/rush_job_mongoid_polling_controller';
import 'bootstrap';

window.Stimulus = Application.start();
Stimulus.register('rush-job-mongoid-polling', RushJobMongoidPollingController);
