import { Autocomplete } from "stimulus-autocomplete"

export default class extends Autocomplete {

  commit(selected) {
    // クリックされた要素から商品詳細ページのURLを取得
    const productUrl = selected.getAttribute("data-autocomplete-product-url")
    
    // URLが存在する場合は商品詳細ページへ遷移
    if (productUrl) {
      window.location.href = productUrl
    } else {
      // URLがない場合はフォームに値を入れる
      super.commit(selected)
    }
  }
}