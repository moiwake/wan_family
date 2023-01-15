let reviewCount = document.getElementById("review-grid-list")
let rating

if (reviewCount) {
  displayAllRatings("dog-rating");
  displayAllRatings("human-rating");
} else if (!reviewCount) {
  rating = document.getElementById("dog-rating")
  displayRating(rating);
  rating = document.getElementById("human-rating")
  displayRating(rating);
}

function displayAllRatings(ratingElementId) {
  for (let i = 0; i < reviewCount.dataset.reviewCount; i++) {
    rating = document.getElementById(ratingElementId + i)
    displayRating(rating);
  }
};

function displayRating(rating) {
  let ratingIcon = rating.children;
  let ratingValue = rating.dataset.reviewScore

  for (let j = 0; j < ratingValue; j++){
    ratingIcon[j].classList.remove("non-colored");
    ratingIcon[j].classList.add("colored");
  }
}
