let ratings = document.getElementsByClassName("js-rating");

for (let i = 0; i < ratings.length; i++) {
  let rating = ratings[i].children;
  let ratingValue = document.getElementsByClassName("js-score")[i].value;
  let index;

  if (!ratingValue == 0) {
    for (let j = 0; j < ratingValue; j++){
      rating[j].classList.remove("js-non-colored");
      rating[j].classList.add("js-colored");
    }
  }

  for (let j = 0; j < rating.length; j++){
    rating[j].addEventListener("mouseover", function(){
      for(let k = 0; k <= j; k++){
        rating[k].classList.remove("js-non-colored");
        rating[k].classList.add("js-colored");
      }
    })

    rating[j].addEventListener("click", function(){
      document.getElementsByClassName("js-score-input")[i].value = j + 1;
      index = j;
    })

    rating[j].addEventListener("mouseout", function(){
      for (let k = 0; k < rating.length; k++){
        rating[k].classList.remove("js-colored");
        rating[k].classList.add("js-non-colored");
      }

      if (!ratingValue == 0) {
        for (let k = 0; k < ratingValue; k++){
          rating[k].classList.add("js-colored");
        }
      }

      for (let k = 0; k <= index; k++){
        rating[k].classList.remove("js-non-colored");
        rating[k].classList.add("js-colored");
      }
    })
  }
}
