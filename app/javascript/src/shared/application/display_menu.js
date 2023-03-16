addEventListener("DOMContentLoaded", function () {
  let burger = document.getElementsByClassName("js-trigger-burger")[0];
  let menu = document.getElementById(burger.dataset.target);

  burger.addEventListener("click", function () {
    if (burger.classList.contains("is-active")) {
      burger.classList.remove("is-active");
      menu.classList.remove("is-active");
    } else {
      burger.classList.add("is-active");
      menu.classList.add("is-active");
    }
  });
});
