import { Controller } from '@hotwired/stimulus';

export class RushJobMongoidTableUpdateController extends Controller {
  async updateJobs() {
    const headers = { 'Accept': 'text/vnd.turbo-stream.html' };

    this.blurTable();
    this.clearFlash();

    try {
      const response = await fetch(document.location.href, { headers: headers });

      if (!response.ok) {
        throw new Error(`Failed to fetch job data. Status: ${response.status}`);
      }

      const response_text = await response.text();
      Turbo.renderStreamMessage(response_text);
    } catch (error) {
      console.error(error.message);
    }
  }

  blurTable() {
    const jobsContainer = document.getElementById('rush-job-mongoid-jobs');
    jobsContainer.classList.add('opacity-25');
  }

  clearFlash() {
    document.getElementById('rush-job-mongoid-flash-messages').innerHTML = '';
  }
}
