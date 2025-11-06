import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.isChecking) return
    this.isChecking = true

    // すでに読み込み済みかチェック
    if (this.isPageAlreadyLoaded()) {
      this.hideLoaderImmediately() // アニメーションなしで即座に非表示
      return
    }

    this.checkImagesLoaded()
  }

  disconnect() {
    this.isChecking = false
    if (this.timeoutId) clearTimeout(this.timeoutId)
  }

  isPageAlreadyLoaded() {
    // DOMContentLoadedが完了しているか
    if (document.readyState === 'complete') {
      const container = document.querySelector('main') || document.body
      const images = container.querySelectorAll('img')

      // 画像がない、または全て読み込み済みの場合
      if (images.length === 0) return true

      // 全ての画像が読み込み済みかチェック
      return Array.from(images).every(img =>
        img.complete && img.naturalHeight !== 0
      )
    }
    return false
  }

  checkImagesLoaded() {
    const container = document.querySelector('main') || document.body
    const images = container.querySelectorAll('img')

    if (images.length === 0) {
      this.hideLoader()
      return
    }

    let loadedImages = 0
    const totalImages = images.length

    const checkComplete = () => {
      loadedImages++
      if (loadedImages === totalImages) {
        this.hideLoader()
      }
    }

    images.forEach((img) => {
      if (img.complete && img.naturalHeight !== 0) {
        checkComplete()
      } else {
        img.addEventListener('load', checkComplete, { once: true })
        img.addEventListener('error', checkComplete, { once: true })
      }
    })

    if (loadedImages === totalImages) {
      this.hideLoader()
      return
    }

    this.timeoutId = setTimeout(() => {
      this.hideLoader()
    }, 3000)
  }

  hideLoaderImmediately() {
    // アニメーションなしで即座に削除
    this.element.remove()
    window.dispatchEvent(new CustomEvent('loading:complete'))
  }

  hideLoader() {
    if (this.element.classList.contains('opacity-0')) return

    this.element.classList.remove('opacity-100')
    this.element.classList.add('opacity-0')

    setTimeout(() => {
      this.element.remove()
      window.dispatchEvent(new CustomEvent('loading:complete'))
    }, 700)
  }
}