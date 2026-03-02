import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Auto-hide after 3 seconds
    setTimeout(() => {
      this.element.classList.add("opacity-0", "translate-y-2")
      setTimeout(() => this.element.remove(), 500)
    }, 3000)
  }
}
