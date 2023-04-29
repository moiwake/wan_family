addEventListener("DOMContentLoaded", function () {
  let searchFormWraps = document.getElementsByClassName("js-search-form-wrap");

  for (let i = 0; i < searchFormWraps.length; i++) {
    let clearBtn = document.getElementsByClassName("js-search-condition-clear-btn")[i];

    clearBtn.addEventListener("click", function () {
      let optionsWraps = searchFormWraps[i].getElementsByClassName("js-target-options-wrap");
      for (let j = 0; j < optionsWraps.length; j++) {
        let options = optionsWraps[j].children;

        for (let k = 0; k < options.length; k++) {
          options[k].checked = false;
          options[k].classList.remove("js-colored-option-btn");
        }
      }

      let input = searchFormWraps[i].getElementsByClassName("js-name-or-address-input")[0];
      input.value = ""

      let selects = searchFormWraps[i].querySelectorAll("select");

      for (let j = 0; j < selects.length; j++) {
        let selectOpts = selects[j].children;
        selectOpts[0].setAttribute("selected", "selected")

        for (let k = 0; k < selectOpts.length; k++) {
          selectOpts[k].removeAttribute("selected");
          selectOpts[k].classList.remove("js-colored-option-btn");
        }
      }
    });
  }
});
