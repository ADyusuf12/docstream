import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "label"]

  connect() {
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("dragleave", this.dragLeave.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
  }

  dragOver(e) {
    e.preventDefault()
    this.element.classList.add("border-tirs-medium", "bg-emerald-50")
  }

  dragLeave() {
    this.element.classList.remove("border-tirs-medium", "bg-emerald-50")
  }

  drop() {
    this.element.classList.remove("border-tirs-medium", "bg-emerald-50")
  }

  changed() {
    const file = this.inputTarget.files[0]
    if (file) {
      this.labelTarget.classList.add("hidden")
      this.previewTarget.classList.remove("hidden")
      this.previewTarget.querySelector(".filename").textContent = file.name
      this.element.classList.add("border-emerald-500", "bg-emerald-50/30")
    }
  }
}