document.addEventListener("turbo:render", () => {
  // .sweetness-radioクラスが付いた、選択状態（checked）のラジオボタンをすべて取得
  document.querySelectorAll('input[type="radio"].sweetness-radio:checked').forEach((el) => {
    // それぞれのラジオボタンに対して、changeイベントを強制的に発火させる
    // これによって、Tailwind CSSのpeer-checkedなどのスタイルが正しく再適用される
    el.dispatchEvent(new Event('change', { bubbles: true }));
  });
});