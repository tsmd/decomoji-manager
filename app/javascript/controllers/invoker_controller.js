import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { target: String };

  invoke() {
    const target = document.getElementById(this.targetValue);
    this.dispatch("invoke", { target });
  }
}
