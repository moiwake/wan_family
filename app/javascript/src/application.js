window.onload = function() {
  displaySearch();
  displayFilter();
  displayMenu();
}

function displaySearch() {
  let headerSearch = document.getElementsByClassName("js-target-header-search")[0];
  let searchFormOpenBtn = document.getElementsByClassName("js-trigger-search-form-open-btn")[0];

  searchFormOpenBtn.addEventListener("click", function () {
    headerSearch.classList.remove("js-header-search-hidden");
  });

  let searchFormCloseBtn = headerSearch.getElementsByClassName("js-trigger-search-form-close-btn")[0];

  searchFormCloseBtn.addEventListener("click", function () {
    headerSearch.classList.add("js-header-search-hidden");
  });
}

function displayFilter() {
  let filterSearchModal = document.getElementsByClassName("js-target-search-filter")[0];
  let filterOpenBtn = document.getElementsByClassName("js-trigger-search-filter-open-btn")[0];

  filterOpenBtn.addEventListener("click", function () {
    filterSearchModal.classList.add("js-search-filter-open");
  });

  let filterCloseBtn = document.getElementsByClassName("js-trigger-search-filter-close-btn")[0];

  filterCloseBtn.addEventListener("click", function () {
    filterSearchModal.classList.remove("js-search-filter-open");
  });
}

function displayMenu() {
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
}
