addEventListener("DOMContentLoaded", function () {
  let headerSearch = document.getElementsByClassName("js-target-header-search")[0];
  let searchFormOpenBtn = document.getElementsByClassName("js-trigger-search-form-open-btn")[0];

  searchFormOpenBtn.addEventListener("click", function () {
    headerSearch.classList.remove("js-header-search-hidden");

    let burger = document.getElementsByClassName("js-trigger-burger")[0];
    let menu = document.getElementById(burger.dataset.target);
    if (menu.classList.contains("is-active")) {
      menu.classList.remove("is-active");
      burger.classList.remove("is-active");
    }
  });

  let searchFormCloseBtn = headerSearch.getElementsByClassName("js-trigger-search-form-close-btn")[0];

  searchFormCloseBtn.addEventListener("click", function () {
    headerSearch.classList.add("js-header-search-hidden");
  });
});
