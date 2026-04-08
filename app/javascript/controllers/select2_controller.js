import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $(this.element).select2({
      theme: "bootstrap-5",
      placeholder: this.element.dataset.placeholder || "選択してください",
      allowClear: true,
    })
  }

  disconnect() {
    $(this.element).select2("destroy")
  }
}
