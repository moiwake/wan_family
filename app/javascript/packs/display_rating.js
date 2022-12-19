let reviewsLength = document.getElementById("reviews-count");

if (reviewsLength) {
  displayRating("#dog-ratings", "dog-rating-value");
  displayRating("#human-ratings", "human-rating-value");

  function displayRating(ratingClass, ratingValueClass) {
    for (let i = 0; i < reviewsLength.value; i++) {
      let reviewId = document.getElementById("review-id" + i).value
      let rating = document.querySelector(ratingClass + reviewId).children;
      let ratingValue = document.getElementById(ratingValueClass + reviewId);

      for (let j = 0; j < ratingValue.value; j++){
        rating[j].classList.remove("non-colored");
        rating[j].classList.add("colored");
      }
    }
  };
} else if (!reviewsLength) {
  displayRating(".dog-ratings", "dog-rating-value");
  displayRating(".human-ratings", "human-rating-value");

  function displayRating(ratingClass, ratingValueClass) {
    let rating = document.querySelector(ratingClass).children;
    let ratingValue = document.getElementById(ratingValueClass);

    for (let j = 0; j < ratingValue.value; j++){
      rating[j].classList.remove("non-colored");
      rating[j].classList.add("colored");
    }
  };
}
