let opened

window.addEventListener('DOMContentLoaded', hiddenCard);
window.addEventListener('resize', hiddenCard);

function hiddenCard() {
  if (opened !== "true") {
    let cards = document.getElementsByClassName("js-card");
    let cover = document.getElementsByClassName("js-card-cover")

    for (let i = 0; i < cards.length; i++) {
      cover[i].classList.add("js-hidden-card");
      cards[i].classList.remove("js-resize-card");

      if (cards[i].clientHeight > 500) {
        cover[i].classList.remove("js-hidden-card");
        cards[i].classList.add("js-resize-card");

        let openIcon = cover[i].querySelector("i");
        openIcon.addEventListener("click", function () {
          cover[i].classList.add("js-hidden-card");
          cards[i].classList.remove("js-resize-card");

          opened = "true";
        });
      }
    }
  }
}
