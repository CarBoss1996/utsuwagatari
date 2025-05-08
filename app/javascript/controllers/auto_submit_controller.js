import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  connect() {
    console.log("auto_submit に接続しました。")
  }

  submit() {
    const form = this.inputTarget.form
    if (form) {
      form.requestSubmit()
    } else {
      console.error("フォームが見つかりませんでした")
    }
  }
}
