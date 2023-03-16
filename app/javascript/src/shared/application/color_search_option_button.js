addEventListener("DOMContentLoaded", function () {
  let optionsWraps = document.getElementsByClassName("js-target-options-wrap");

  for (let i = 0; i < optionsWraps.length; i++) {
    let labels = optionsWraps[i].querySelectorAll("label");

    for (let j = 0; j < labels.length; j++) {
      labels[j].classList.add("button", "is-small");

      labels[j].addEventListener("click", function () {
        if (labels[j].classList.contains("js-colored-option-btn")) {
          labels[j].classList.remove("js-colored-option-btn");
        } else {
          labels[j].classList.add("js-colored-option-btn");
        }
      });

      let checkbox = document.getElementById(labels[j].htmlFor);
      if (checkbox.checked) {
        labels[j].classList.add("js-colored-option-btn");
      }
    }
  }
});
