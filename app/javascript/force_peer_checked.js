document.addEventListener("turbo:load", () => {
  // .sweetness-radioクラスが付いた全てのラジオボタンを取得して、1つずつ処理する
  document.querySelectorAll('input[type="radio"].sweetness-radio').forEach((el) => {
    // それぞれのラジオボタンに「change」イベント（値が変わったときに発火）を設定する
    el.addEventListener('change', (e) => {
      // 同じname属性を持つ（＝同じグループの）ラジオボタンをすべて取得し、1つずつ処理する
      document.querySelectorAll(`input[name="${el.name}"]`).forEach((peer) => {
        // そのラジオボタンに「input」イベントを強制的に発火させる
        peer.dispatchEvent(new Event('input', { bubbles: true }));
      });
    });
  });
});