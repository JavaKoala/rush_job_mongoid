import { Controller } from '@hotwired/stimulus';

export default class RushJobMongoidConfirmController extends Controller {
  displayConfirm(e) {
    const confirmMessage = e.target.dataset.confirmMessage;

    if (confirm(confirmMessage) !== true) {
      e.preventDefault();
    }
  }
}
