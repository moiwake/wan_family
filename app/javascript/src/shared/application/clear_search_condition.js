addEventListener("DOMContentLoaded", function () {
  let clearBtn = document.getElementsByClassName("js-search-condition-clear-btn")[0];

  clearBtn.addEventListener("click", function () {
    let searchFilterWrap = document.getElementsByClassName("js-search-filter-wrap")[0];
    let optionsWraps = searchFilterWrap.getElementsByClassName("js-target-options-wrap");

    for (let i = 0; i < optionsWraps.length; i++) {
      let options = optionsWraps[i].children;

      for (let j = 0; j < options.length; j++) {
        options[j].removeAttribute("checked");
        options[j].classList.remove("js-colored-option-btn");
      }
    }

    let selects = searchFilterWrap.querySelectorAll("select");

    for (let i = 0; i < selects.length; i++) {
      let selectOpts = selects[i].children;

      selectOpts[0].setAttribute("selected", "selected")

      for (let j = 0; j < selectOpts.length; j++) {
        selectOpts[j].removeAttribute("selected");
        selectOpts[j].classList.remove("js-colored-option-btn");
      }
    }
  });
});
