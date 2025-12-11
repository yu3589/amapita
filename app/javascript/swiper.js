document.addEventListener("turbo:load", () => {
  initSwiper();
});

function initSwiper() {
  const swiper = new Swiper(".swiper", {
    // Optional parameters
    direction: "horizontal",
    loop: false,
    speed: 600,
    spaceBetween: 20,

    // pagination: {
    //   el: ".swiper-pagination",
    // },

    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
  });
}