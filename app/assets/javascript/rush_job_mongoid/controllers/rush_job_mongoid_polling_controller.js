import { Controller } from '@hotwired/stimulus';

export default class RushJobMongoidPollingController extends Controller {
  static targets = ['pollingTime', 'pollingTimeLabel'];

  connect() {
    this.pollingChange();
  }

  pollingChange() {
    const pollingLabelRegex = /\d+/;
    const pollingTimeTargetHtml = this.pollingTimeLabelTarget.innerHTML;
    const pollingLabelUpdate = pollingTimeTargetHtml.replace(pollingLabelRegex, this.pollingTime());
    this.pollingTimeLabelTarget.innerHTML = pollingLabelUpdate;
  }

  pollingTime() {
    const pollingTimes = [3, 5, 8, 13, 21, 34, 55];
    const pollingTime = this.pollingTimeTarget.value || 3;

    return pollingTimes[pollingTime];
  }
}
