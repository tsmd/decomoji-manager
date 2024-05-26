import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["anchor"];

  click() {
    this.anchorTarget.click();
  }
}
