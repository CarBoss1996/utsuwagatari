import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { readUrl: String }

  toggle(event) {
    if (event.target.open) {
      fetch(this.readUrlValue, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
      }).then(() => {
        this.element.querySelector(".unread-badge")?.remove()
      })
    }
  }
}
