setRating(".dog-ratings", "dog-rating-value");
setRating(".human-ratings", "human-rating-value");

function setRating(ratingClass, ratingValueClass) {
  const rating = document.querySelector(ratingClass).children;
  const ratingValue = document.getElementById(ratingValueClass);
  let index;

  for (let i = 0; i < rating.length; i++){
    if (!ratingValue.value == 0) {
      for (let j = 0; j < ratingValue.value; j++){
        rating[j].classList.remove("non-colored");
        rating[j].classList.add("colored");
      }
    }

    rating[i].addEventListener("mouseover", function(){
      for(let j = 0; j <= i; j++){
        rating[j].classList.remove("non-colored");
        rating[j].classList.add("colored");
      }
    })

    rating[i].addEventListener("click", function(){
      ratingValue.value = i + 1;
      index = i;
    })

    rating[i].addEventListener("mouseout", function(){
      for (let j = 0; j < rating.length; j++){
        rating[j].classList.remove("colored");
        rating[j].classList.add("non-colored");
      }

      if (!ratingValue.value == 0) {
        for (let j = 0; j < ratingValue.value; j++){
          rating[j].classList.add("colored");
        }
      }

      for (let j = 0; j <= index; j++){
        rating[j].classList.remove("non-colored");
        rating[j].classList.add("colored");
      }
    })
  }
};
