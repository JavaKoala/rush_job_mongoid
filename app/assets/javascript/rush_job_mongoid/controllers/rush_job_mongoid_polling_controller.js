import { RushJobMongoidTableUpdateController } from 'rush_job_mongoid/controllers/rush_job_mongoid_table_update_controller';

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
    this.stopPolling();
    this.updateJobs();

    let progressInterval = 100;
    let progressPrecent = 1;
    let progressIntervalTime = this.pollingTime() * 10;

    if (progressIntervalTime < 130) {
      progressPrecent = 10;
      progressIntervalTime = progressIntervalTime * 10;
    }

    intervalID = setInterval(() => {
      this.progressBarProgressTarget.style = `width: ${progressInterval}%;`;
      this.progressBarTarget.setAttribute('aria-valuenow', progressInterval);

      progressInterval -= progressPrecent;

      if (progressInterval < 0) {
        this.startPolling();
      }
    }, progressIntervalTime);
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
