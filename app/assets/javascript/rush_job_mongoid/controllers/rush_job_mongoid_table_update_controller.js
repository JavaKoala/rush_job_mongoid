import { Controller } from '@hotwired/stimulus';

export class RushJobMongoidTableUpdateController extends Controller {
  updateJobs() {
    const headers = { 'Accept': 'text/vnd.turbo-stream.html' };

    this.blurTable();
    this.clearFlash();

    fetch(document.location.href, { headers: headers })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html));
  }

  blurTable() {
    const jobsContainer = document.getElementById('rush-job-mongoid-jobs');
    jobsContainer.classList.add('table-refresh');
  }

  clearFlash() {
    document.getElementById('rush-job-mongoid-flash-messages').innerHTML = '';
  }
}
