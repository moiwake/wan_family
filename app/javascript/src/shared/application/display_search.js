addEventListener("DOMContentLoaded", function () {
  let headerSearch = document.getElementsByClassName("js-target-header-search")[0];
  let searchFormOpenBtn = document.getElementsByClassName("js-trigger-search-form-open-btn")[0];

  searchFormOpenBtn.addEventListener("click", function () {
    headerSearch.classList.remove("js-header-search-hidden");
  });

  let searchFormCloseBtn = headerSearch.getElementsByClassName("js-trigger-search-form-close-btn")[0];

  searchFormCloseBtn.addEventListener("click", function () {
    headerSearch.classList.add("js-header-search-hidden");
  });
});
