let list = document.getElementsByClassName("js-spot-list")[0];

if (list) {
  displayAllRatings();
} else if (!list) {
  let ratings = document.getElementsByClassName("js-rating");
  let ratingValues = document.getElementsByClassName("js-score");

  displayRating(ratings, ratingValues);
}

function displayAllRatings() {
  for (let i = 0; i < list.children.length; i++) {
    let ratings = list.children[i].getElementsByClassName("js-rating");
    let ratingValues = list.children[i].getElementsByClassName("js-score");

    displayRating(ratings, ratingValues);
  }
};

function displayRating(ratings, ratingValues) {
  for (let j = 0; j < ratings.length; j++) {
    let ratingIcons = ratings[j].children;
    let ratingValue = ratingValues[j].innerText;

    for (let k = 0; k < ratingValue; k++) {
      ratingIcons[k].classList.remove("js-non-colored");

      if (k == Math.floor(ratingValue)) {
        let ratingDecimal = Math.round((ratingValue - Math.floor(ratingValue)) * 10) / 10;
        ratingIcons[k].classList.add("js-partial-color");

        if (ratingDecimal == 0.9) {
          ratingIcons[k].classList.add("js-nine-tenths-color");
        } else if (ratingDecimal == 0.8) {
          ratingIcons[k].classList.add("js-four-fifths-color");
        } else if (ratingDecimal == 0.7) {
          ratingIcons[k].classList.add("js-seven-tenths-color");
        } else if (ratingDecimal == 0.6) {
          ratingIcons[k].classList.add("js-three-fifths-color");
        } else if (ratingDecimal == 0.5) {
          ratingIcons[k].classList.add("js-half-color");
        } else if (ratingDecimal == 0.4) {
          ratingIcons[k].classList.add("js-two-fifths-color");
        } else if (ratingDecimal == 0.3) {
          ratingIcons[k].classList.add("js-three-tenths-color");
        } else if (ratingDecimal == 0.2) {
          ratingIcons[k].classList.add("js-one-fifth-color");
        } else if (ratingDecimal == 0.1) {
          ratingIcons[k].classList.add("js-one-tenth-color");
        }
      } else {
        ratingIcons[k].classList.add("js-colored");
      }
    }
  }
}
