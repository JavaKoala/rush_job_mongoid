import { RushJobMongoidTableUpdateController } from './rush_job_mongoid_table_update_controller';

export default class extends RushJobMongoidTableUpdateController {
  reloadJobs() {
    this.updateJobs();
  }
}
