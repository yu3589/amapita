import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "checkbox" ]

  connect() {
    this.update()
  }

  update() {
    if (this.checkboxTarget.checked) {
      this.show()
    } else {
      this.hide()
    }
  }

  show() {
    this.inputTarget.type = "text"
  }

  hide() {
    this.inputTarget.type = "password"
  }
}