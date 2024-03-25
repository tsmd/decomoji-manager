import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];

  // Bind this method to click event.
  // A click event always occurs prior to a change event.
  memoShiftKey(e) {
    if (!e.target.matches("input[type='checkbox']")) return;
    this.shiftKey = e.shiftKey;

    setTimeout(() => {
      this.shiftKey = false;
    });
  }

  handleCheck(e) {
    if (this.shiftKey && this.lastTarget) {
      const startIndex = this.checkboxTargets.indexOf(this.lastTarget);
      const endIndex = this.checkboxTargets.indexOf(e.target);

      for (let i = Math.min(startIndex, endIndex); i <= Math.max(startIndex, endIndex); i++) {
        this.checkboxTargets[i].checked = this.lastChecked;
      }
    }

    this.lastTarget = e.target;
    this.lastChecked = e.target.checked;
  }
}
