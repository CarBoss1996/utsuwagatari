import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper/bundle"

export default class extends Controller {
  static targets = ["main"]
  static values = {
    url: String
  }

  connect() {
    new Swiper(".thumb-swiper", {
      spaceBetween: 10,
      slidesPerView: 4,
      freeMode: true
    })
  }

  swap(event) {
    const url = event.currentTarget.dataset.imageGalleryUrlValue
    this.mainTarget.src = url
  }
}
