import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  open() {
    this.panelTarget.classList.remove("d-none")
  }

  close() {
    this.panelTarget.classList.add("d-none")
  }

  backdrop(event) {
    if (event.target === this.panelTarget)
    this.close()
  }

  stop(event) {
    event.stopPropagation()
  }
}
