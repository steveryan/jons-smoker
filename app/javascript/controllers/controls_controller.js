// app/javascript/controllers/controls_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    console.log("Controls controller connected");
    this.refreshFrame();
    this.interval = setInterval(() => this.refreshFrame(), 2000);
  }

  disconnect() {
    clearInterval(30000);
  }

  refreshFrame() {
    console.log("Refreshing frame");
    const frame = document.getElementById("current_status");
    if (frame && !frame.contains(document.getElementById("form"))) {
      frame.src = "/controls/status";
    }
  }
}