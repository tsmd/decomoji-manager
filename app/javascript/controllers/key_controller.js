import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  handle(e) {
    switch (e.key) {
      case "Escape":
        this.dispatch("esc");
    }
  }
}
