function updateSweetnessRadioHighlight() {
  // すべての色をリセット
  document.querySelectorAll('.sweetness-radio').forEach((radio) => {
    radio.closest('label').querySelector('.rating-indicator').classList.remove(
      'bg-accent', 'bg-primary', 'bg-secondary'
    );
  });
  // checkedのものだけ色を付ける
  document.querySelectorAll('input[type="radio"].sweetness-radio:checked').forEach((radio) => {
    const indicator = radio.closest('label').querySelector('.rating-indicator');
    if (radio.value === "lack_of_sweetness" || radio.value === "could_be_sweeter") {
      indicator.classList.add('bg-accent');
    } else if (radio.value === "perfect_sweetness") {
      indicator.classList.add('bg-primary');
    } else if (radio.value === "slightly_too_sweet" || radio.value === "too_sweet") {
      indicator.classList.add('bg-secondary');
    }
  });
}

// Turboの描画イベントごとにイベント登録と初期化をやり直す
function setupSweetnessRadioHighlight() {
  // まず全てのイベントリスナーを解除（同じイベントが重複しないように）
  document.querySelectorAll('.sweetness-radio').forEach((radio) => {
    radio.replaceWith(radio.cloneNode(true));
  });

  // 再度イベント登録
  document.querySelectorAll('.sweetness-radio').forEach((radio) => {
    radio.addEventListener('change', updateSweetnessRadioHighlight);
    radio.addEventListener('input', updateSweetnessRadioHighlight);
  });

  // 初期状態の色付け
  updateSweetnessRadioHighlight();
}

// Turboの描画イベントで毎回セットアップ
document.addEventListener("turbo:load", setupSweetnessRadioHighlight);
document.addEventListener("turbo:render", setupSweetnessRadioHighlight);