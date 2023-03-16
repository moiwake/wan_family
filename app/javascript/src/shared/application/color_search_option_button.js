addEventListener("DOMContentLoaded", function () {
  let optionsWrap = document.getElementsByClassName("js-target-options-wrap");

  for (let i = 0; i < optionsWrap.length; i++) {
    let labels = optionsWrap[i].querySelectorAll("label");

    for (let j = 0; j < labels.length; j++) {
      labels[j].classList.add("button", "is-small");

      labels[j].addEventListener("click", function () {
        if (labels[j].classList.contains("js-colored-option-btn")) {
          labels[j].classList.remove("js-colored-option-btn");
        } else {
          labels[j].classList.add("js-colored-option-btn");
        }
      });
    }
  }
});
