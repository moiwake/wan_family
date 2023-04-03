addEventListener("DOMContentLoaded", function () {
  activeDropDownBtn();
  openDropDownItem(0);
});

let showMoreTrigger = document.getElementsByClassName("js-show-more-trigger")[0];
var displayNum

showMoreTrigger.addEventListener("click", function () {
  openDropDownItem(displayNum);
});

function activeDropDownBtn() {
  let tagDropDown = document.getElementsByClassName("js-tag-dropdown")[0];
  let tagDropDownBtn = document.getElementsByClassName("js-dropdown-btn")[0];

  tagDropDownBtn.addEventListener("click", function () {
    if (tagDropDown.classList.contains("is-active")) {
      tagDropDown.classList.remove("is-active");
    } else {
      tagDropDown.classList.add("is-active");
    }
  });
}

function openDropDownItem(index) {
  let dropDownItems = document.getElementsByClassName("js-dropdown-item");

  for (let i = index; i < (index + 10); i++) {
    if (dropDownItems[i]) {
      dropDownItems[i].classList.remove("js-hidden");
    }

    displayNum = (i + 1)
  }

  if (!dropDownItems[dropDownItems.length - 1].classList.contains("js-hidden")) {
    showMoreTrigger.classList.add("js-hidden");
  }
}
