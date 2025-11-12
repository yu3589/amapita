import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["urlSection", "fileSection", "removeImageFlag"]

  connect() {
    // 初期状態を設定
    const checkedRadio = document.querySelector('input[name="image_source"]:checked')
    if (checkedRadio) {
      this.toggle({ target: checkedRadio })
    }
  }

  toggle(event) {
    const value = event.target.value

    if (value === "url") {
      // 楽天画像を選択
      this.urlSectionTarget.classList.remove("hidden")
      this.fileSectionTarget.classList.add("hidden")
      
      if (this.hasRemoveImageFlagTarget) {
        this.removeImageFlagTarget.value = "true"
      }
    } else if (value === "uploaded") {
      // アップロード画像を選択
      this.urlSectionTarget.classList.add("hidden")
      this.fileSectionTarget.classList.remove("hidden")
      
      if (this.hasRemoveImageFlagTarget) {
        this.removeImageFlagTarget.value = "false"
      }
    }
  }
}