import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["categorySelect", "categoryItemSelect"]
  static values = { items: Object }

  connect() {
    this.categoryItems = this.itemsValue
    // 初期表示時にセレクトを復元する処理を追加したければここに書く
  }

  updateCategoryItems(event) {
    const categoryId = event.target.value
    const wrapper = event.target.closest("[data-controller='category-item']")

    const itemSelect = wrapper.querySelector("[data-category-item-target='categoryItemSelect']")
    const items = this.categoryItems[categoryId] || []

    itemSelect.innerHTML = ""
    const placeholder = document.createElement("option")
    placeholder.text = "選択してください"
    placeholder.value = ""
    itemSelect.appendChild(placeholder)

    items.forEach(item => {
      const option = document.createElement("option")
      option.value = item.id
      option.text = item.name
      itemSelect.appendChild(option)
    })
  }
}
