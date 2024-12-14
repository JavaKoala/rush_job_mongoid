import { RushJobMongoidTableUpdateController } from './rush_job_mongoid_table_update_controller';

let intervalID;

export default class RushJobMongoidPollingController extends RushJobMongoidTableUpdateController {
  static targets = ['pollingTime', 'pollingTimeLabel', 'pollingSlide', 'progressBar', 'progressBarProgress'];

  connect() {
    this.pollingChange();
    this.stopPolling();
  }

  pollingChange() {
    const pollingLabelRegex = /\d+/;
    const pollingTimeTargetHtml = this.pollingTimeLabelTarget.innerHTML;
    const pollingLabelUpdate = pollingTimeTargetHtml.replace(pollingLabelRegex, this.pollingTime());
    this.pollingTimeLabelTarget.innerHTML = pollingLabelUpdate;
  }

  pollingToggle() {
    const pollingSlide = this.pollingSlideTarget;

    if (pollingSlide.checked === true) {
      this.startPolling();
      this.progressBarTarget.style = 'height: 7px;';
    } else {
      this.stopPolling();
      this.progressBarTarget.style = 'display: none;';
    }
  }

  startPolling() {
    this.updateJobs();

    intervalID = setTimeout(() => {
      this.startPolling();
    }, this.pollingTime() * 1000);
  }

  stopPolling() {
    if (intervalID) {
      clearInterval(intervalID);
    }
  }

  pollingTime() {
    const pollingTimes = [3, 5, 8, 13, 21, 34, 55];
    const pollingTime = this.pollingTimeTarget.value || 3;

    return pollingTimes[pollingTime];
  }
}
