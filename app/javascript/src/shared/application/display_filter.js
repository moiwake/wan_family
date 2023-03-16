addEventListener("DOMContentLoaded", function () {
  let filterSearchModal = document.getElementsByClassName("js-target-search-filter-overlay")[0];
  let filterOpenBtn = document.getElementsByClassName("js-trigger-search-filter-open-btn")[0];

  filterOpenBtn.addEventListener("click", function () {
    filterSearchModal.classList.add("js-search-filter-open");
  });

  let filterCloseBtn = document.getElementsByClassName("js-trigger-search-filter-close-btn")[0];

  filterCloseBtn.addEventListener("click", function () {
    filterSearchModal.classList.remove("js-search-filter-open");
  });
});
