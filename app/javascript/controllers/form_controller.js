import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  requestSubmit() {
    this.formTarget.requestSubmit();
  }
}
