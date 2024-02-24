import { Controller } from '@hotwired/stimulus';
import Rails from '@rails/ujs';

export default class RushJobMongoidTableUpdateController extends Controller {
  updateJobs() {
    this.blurTable();

    Rails.ajax({
      url: document.location.href,
      type: 'GET',
      dataType: 'script',
    });
  }

  blurTable() {
    const jobsContainer = document.getElementById('rush-job-mongoid-jobs');
    jobsContainer.classList.add('table-refresh');
  }
}
