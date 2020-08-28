import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["input", "count"];

  recount() {
    var count = this.inputTarget.value.length;
    this.countTarget.textContent = count;
    if (count >= parseInt(this.data.get("danger"))) {
      this.inputTarget.className = "textarea is-danger";
    } else if (count >= parseInt(this.data.get("warn"))) {
      this.inputTarget.className = "textarea is-warning";
    } else {
      this.inputTarget.className = "textarea";
    }
  }

  connect() {
    this.recount();
  }
}
