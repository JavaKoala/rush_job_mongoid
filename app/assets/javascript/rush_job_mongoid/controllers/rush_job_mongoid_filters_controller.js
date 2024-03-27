import { Controller } from '@hotwired/stimulus';

export default class RushJobMongoidFiltersController extends Controller {
  static targets = ['input'];

  clearForm() {
    this.inputTargets.forEach((input) => input.value = '');
  }
}
