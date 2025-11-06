import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 初期状態で非表示
    this.element.classList.add('opacity-0')
    
    // ローディング完了を待つ
    window.addEventListener('loading:complete', () => {
      this.showMessage()
    }, { once: true })
    
    // ローディングが既に完了している場合（ローダーが存在しない）
    if (!document.getElementById('page-loader')) {
      this.showMessage()
    }
  }

  showMessage() {
    this.element.classList.add('transition-opacity', 'duration-300')

    this.element.classList.remove('opacity-0')
    this.element.classList.add('opacity-100')

    setTimeout(() => {
      this.element.classList.remove('opacity-100')
      this.element.classList.add('opacity-0')
      
      setTimeout(() => {
        this.element.remove()
      }, 300)
    }, 2500)
  }
}