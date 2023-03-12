window.onload = function() {
  displayFilter();
  displayMenu();
}

function displayFilter() {
  let filterBtn = document.getElementsByClassName("filter-btn")[0];
  let modal = document.getElementsByClassName("modal")[0];

  filterBtn.addEventListener("click", function () {
    modal.classList.add("open");
  });

  let deleteBtn = document.getElementsByClassName("delete")[0];
  deleteBtn.addEventListener("click", function () {
    modal.classList.remove("open");
  });
}

function displayMenu() {
  let burger = document.getElementsByClassName("burger")[0];
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
