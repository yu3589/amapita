import { Controller } from "@hotwired/stimulus"
// モバイル時のブラウザバック問題を回避するためのクエリパラメータ追加
export default class extends Controller {
  connect() {
    const url = new URL(this.element.href, window.location.origin) // URLオブジェクトを作成
    if (window.innerWidth < 640) {
      url.searchParams.set("from_post", "true") // キャッシュ問題回避のため
      this.element.href = url.toString() // URLオブジェクトを文字列に変換
    }
  }
}