import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "keyword", "url", "imageUrl", "shopName",
    "loading", "error", "errorMessage", "results", "categorySelect",
    "manufacturer"
  ]
  
  validateKeyword(keyword) {
    if (!keyword || keyword.trim() === '') {
      return { valid: false, message: "商品名を入力してください" }
    }
    
    const trimmedKeyword = keyword.trim()

    if (trimmedKeyword.length < 2) {
      return { valid: false, message: "2文字以上で入力してください" }
    }

    if (trimmedKeyword.length > 40) {
      return { valid: false, message: "40文字以内で入力してください" }
    }

    const VALID_PATTERN = /^[a-zA-Z0-9\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF\s\-_()（）・&＆！!？?]+$/
    if (!VALID_PATTERN.test(trimmedKeyword)) {
      return { valid: false, message: "使用できない文字が含まれています" }
    }
    
    return { valid: true, keyword: trimmedKeyword }
  }

  search() {
    const keyword = this.keywordTarget.value

    const validation = this.validateKeyword(keyword)
    if (!validation.valid) {
      this.showError(validation.message)
      return
    }
    this.performSearch(validation.keyword)
  }

  performSearch(keyword) {
    this.showLoading()

    const encodedKeyword = encodeURIComponent(keyword)

    fetch(`/posts/search_products?keyword=${encodedKeyword}`)
      .then(response => {
        return response.json()
      })
      .then(data => {
        this.hideLoading()
        
        if (data && data.length > 0) {
          this.showResults(data)
          this.hideError()
        } else {
          this.showError("商品が見つかりませんでした")
        }
      })
      .catch(error => {
        console.error("エラー:", error)
        this.hideLoading()
        this.showError("通信エラーが発生しました")
      })
  }

  // 候補の表示
  showResults(results) {
    let html = `
      <div class="card-actions justify-center pb-3">
        <button 
          type="button" 
          class="btn btn-soft btn-sm"
          data-action="click->rakuten-search#searchReset">
          検索リセット
        </button>
      </div>
      <div class="max-h-70 w-full sm:max-w-md overflow-y-auto space-y-2 p-1 rounded-box border-2 border-base-200">
    `
    const iconPath = "/assets/store.svg"
    results.forEach(item => {
      html += `
        <label class="card card-compact bg-base-100 shadow hover:bg-secondary/10 cursor-pointer transition w-full">
          <input type="radio" 
            name="rakuten_product" 
            value="${item.url}"
            data-image-url="${item.imageUrl}"
            data-name="${item.name}"
            data-shop-name="${item.shopName}"
            data-action="change->rakuten-search#selectProduct"
            class="hidden peer">
          <div class="card-body peer-checked:bg-secondary/20 p-2 sm:px-3 sm:py-4">
            <div class="flex gap-2 sm:gap-4">
              <img src="${item.imageUrl}" class="w-20 h-20 object-contain" alt="${item.name}">
              <div class="flex-1 flex flex-col justify-center">
                <h3 class="text-sm line-clamp-4 sm:line-clamp-2 text-start">${item.name}</h3>
                <div class="flex items-start text-start gap-1 mt-2">
                  <img src="${iconPath}" class="h-4 w-4 sm:h-5 sm:w-5" alt="Store icon">
                  <p class="text-xs sm:text-sm text-stone-400">${item.shopName}</p>
                </div>
              </div>
            </div>
          </div>
        </label>
      `
    })

    html += '</div>'
    
    this.resultsTarget.innerHTML = html
    this.resultsTarget.classList.remove("hidden")
  }
  
  selectProduct(event) {
    const radio = event.currentTarget
    const imageUrl = radio.dataset.imageUrl
    const url = radio.value
    const name = radio.dataset.name || ""
    const shopName = radio.dataset.shopName || ""
    const iconPath = "/assets/store.svg"

    console.log("📦 選択された商品:", name)

    this.urlTarget.value = url
    this.imageUrlTarget.value = imageUrl

    // メーカー自動入力処理
    const mappingElement = document.getElementById("manufacturer-mapping")
    const manufacturerMapping = JSON.parse(mappingElement.dataset.mapping)

    const matchedManufacturer = Object.keys(manufacturerMapping).find(manufacturer => {
      return manufacturerMapping[manufacturer].some(keyword => name.includes(keyword))
    })

    if (matchedManufacturer) {
      const manufacturerField = document.querySelector('input[name="post[manufacturer]"]')
      if (manufacturerField) {
        manufacturerField.value = matchedManufacturer
      }
    }

    // カテゴリの自動選択
    this.selectCategoryByName(name)

    // メーカーの自動選択
    this.selectManufacturerByName(name)

    // 選択結果表示
    this.resultsTarget.innerHTML = `
      <div class="card card-compact bg-base-100 shadow w-full sm:max-w-lg ring ring-stone-200">
        <div class="card-body p-2 sm:px-3 sm:py-4">
          <div class="flex gap-2 sm:gap-4">
            <img src="${imageUrl}" class="w-20 h-20 sm:w-25 sm:h-25 object-contain" alt="${name}">
            <div class="flex-1 flex flex-col justify-center">
              <h3 class="text-sm line-clamp-4 sm:line-clamp-3 text-start">${name}</h3>
              <div class="flex items-start text-start gap-1 mt-2">
                <img src="${iconPath}" class="h-4 w-4 sm:h-5 sm:w-5" alt="Store icon">
                <p class="text-xs sm:text-sm text-stone-400">${shopName}</p>
              </div>
            </div>
          </div>
        </div>
        <div class="card-actions justify-end px-4 pb-3">
          <button type="button" class="btn btn-soft btn-sm"
                  data-action="click->rakuten-search#clear">
            選びなおす
          </button>
        </div>
      </div>
    `
  }

  // メーカーの判定
  selectManufacturerByName(productName) {
    if (!this.hasManufacturerTarget) return

    const mappingElement = document.getElementById("manufacturer-mapping")
    if (!mappingElement) return

    const manufacturerMapping = JSON.parse(mappingElement.dataset.mapping)

    let matchedManufacturer = Object.keys(manufacturerMapping).find(manufacturer => {
      return manufacturerMapping[manufacturer].some(keyword => productName.includes(keyword))
    })

    console.log("🏭 メーカー自動判定:", matchedManufacturer)

    this.manufacturerTarget.value = matchedManufacturer || "その他"
  }

  // カテゴリの判定
  selectCategoryByName(productName) {
    console.log("🧪 商品名:", productName)
    if (!this.hasCategorySelectTarget) {
      console.log("❌ categorySelectターゲットが見つかりません")
      return
    }

    const categorySelect = this.categorySelectTarget

    const mapping = [
      { keyword: "アイス", name: "アイス" },
      { keyword: "シャーベット", name: "アイス" },
      { keyword: "ジェラート", name: "アイス" },
      { keyword: "チョコ", name: "チョコレート" },
      { keyword: "グミ", name: "グミ・ゼリー" },
      { keyword: "ゼリー", name: "グミ・ゼリー" },
      { keyword: "クッキー", name: "クッキー・ビスケット" },
      { keyword: "ビスケット", name: "クッキー・ビスケット" },
      { keyword: "ケーキ", name: "ケーキ" },
      { keyword: "飲料", name: "飲み物" },
      { keyword: "ドリンク", name: "飲み物" },
      { keyword: "ジュース", name: "飲み物" },
      { keyword: "パン", name: "パン・ドーナツ" },
      { keyword: "ぱん", name: "パン・ドーナツ" },
      { keyword: "ドーナツ", name: "パン・ドーナツ" },
      { keyword: "スナック", name: "スナック菓子" }
    ]

    let matchedCategory = mapping.find(m => productName.includes(m.keyword))
    console.log("🧪 マッチしたカテゴリ:", matchedCategory)

    let selected = false

    if (matchedCategory) {
      for (let option of categorySelect.options) {
        console.log(`🔍 比較中: "${option.text.trim()}" に "${matchedCategory.name}" が含まれるか`)
        if (option.text.trim().includes(matchedCategory.name)) {
          console.log(`✅ カテゴリを選択: ${matchedCategory.name} (ID: ${option.value})`)
          categorySelect.value = option.value
          selected = true
          break
        }
      }
    }

    if (!selected) {
      console.log("⚠️ マッチするカテゴリがないため「その他」を選択")
      for (let option of categorySelect.options) {
        if (option.text.trim() === "その他") {
          categorySelect.value = option.value
          selected = true
          console.log(`✅ 「その他」を選択 (ID: ${option.value})`)
          break
        }
      }
    }

    if (selected) {
      categorySelect.dispatchEvent(new Event("change"))
    }
  }

  searchReset() {
    this.urlTarget.value = ""
    this.imageUrlTarget.value = ""
    
    if (this.hasResultsTarget) {
      this.resultsTarget.classList.add("hidden")
      this.resultsTarget.innerHTML = ""
    }

    if (this.hasManufacturerTarget) {
      this.manufacturerTarget.value = ""
    }

    if (this.hasCategorySelectTarget) {
      this.categorySelectTarget.selectedIndex = 0
    }
    
    this.hideError()
  }

  clear() {
    this.keywordTarget.value = ""
    this.urlTarget.value = ""
    this.imageUrlTarget.value = ""
    
    if (this.hasResultsTarget) {
      this.resultsTarget.classList.add("hidden")
      this.resultsTarget.innerHTML = ""
    }

    if (this.hasManufacturerTarget) {
      this.manufacturerTarget.value = ""
    }

    if (this.hasCategorySelectTarget) {
      this.categorySelectTarget.selectedIndex = 0
    }
    
    this.hideError()
  }

  showLoading() {
    this.loadingTarget.classList.remove("hidden")
    this.hideError()
    if (this.hasResultsTarget) {
      this.resultsTarget.classList.add("hidden")
    }
  }
  
  hideLoading() {
    this.loadingTarget.classList.add("hidden")
  }
  
  showError(message) {
    this.errorMessageTarget.textContent = message
    this.errorTarget.classList.remove("hidden")
  }
  
  hideError() {
    if (this.hasErrorTarget) {
      this.errorTarget.classList.add("hidden")
    }
  }
}