import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.checkImagesLoaded()
  }

  checkImagesLoaded() {
    const images = document.querySelectorAll('img')
    
    // 画像がない場合はすぐに非表示
    if (images.length === 0) {
      this.hideLoader()
      return
    }

    let loadedImages = 0
    const totalImages = images.length

    // 全ての画像に対してロード完了を監視
    images.forEach((img) => {
      if (img.complete) {
        // すでに読み込み済みの画像
        loadedImages++
      } else {
        // 読み込み中の画像
        img.addEventListener('load', () => {
          loadedImages++
          if (loadedImages === totalImages) {
            this.hideLoader()
          }
        })
        
        // エラーの場合もカウント（画像が表示できなくてもローディングは消す）
        img.addEventListener('error', () => {
          loadedImages++
          if (loadedImages === totalImages) {
            this.hideLoader()
          }
        })
      }
    })

    // すでに全て読み込み済みの場合
    if (loadedImages === totalImages) {
      this.hideLoader()
    }

    // タイムアウト設定（10秒経ったら強制的に非表示）
    setTimeout(() => {
      this.hideLoader()
    }, 10000)
  }

  hideLoader() {
    // opacity-0にして透明にする
    this.element.classList.remove('opacity-100')
    this.element.classList.add('opacity-0')
    
    // アニメーション完了後に要素を削除
    setTimeout(() => {
      this.element.remove()
      // ローディング完了イベントを発火
      window.dispatchEvent(new CustomEvent('loading:complete'))
    }, 700)
  }
}