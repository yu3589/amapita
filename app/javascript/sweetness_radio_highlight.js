document.addEventListener("turbo:load", () => {
  // すべてのラジオボタン（.sweetness-radio）を取得
  document.querySelectorAll('.sweetness-radio').forEach((radio) => {
    // それぞれのラジオボタンに「選択されたとき」の動きを追加
    radio.addEventListener('change', () => {
      const name = radio.name;
      // // 同じグループの全ラジオボタンについて…
      document.querySelectorAll(`input[name="${name}"]`).forEach((el) => {
        // それぞれのラジオボタンを囲む<label>の中の.rating-indicatorから色を消す
        el.closest('label').querySelector('.rating-indicator').classList.remove(
          'bg-accent', 'bg-primary', 'bg-secondary'
        );
      });
      // 選択されたラジオボタンの.rating-indicatorだけに色を付ける
      // closest('label')で、ラジオボタンを囲む一番近い<label>要素を取得する
      const indicator = radio.closest('label').querySelector('.rating-indicator');
      if (radio.checked) {
        // rating_keyごとに色を切り替え
        if (radio.value === "lack_of_sweetness" || radio.value === "could_be_sweeter") {
          indicator.classList.add('bg-accent');
        } else if (radio.value === "perfect_sweetness") {
          indicator.classList.add('bg-primary');
        } else if (radio.value === "slightly_too_sweet" || radio.value === "too_sweet") {
          indicator.classList.add('bg-secondary');
        }
      }
    });
  });
});