addEventListener("DOMContentLoaded", function () {
  let images = document.getElementsByClassName("js-spot-images");

  for (let i = 0; i < images.length; i++) {
    var smallImages = images[i].getElementsByClassName("js-small-image");
    var largeImage = images[i].getElementsByClassName("js-large-image")[0];

    largeImage.firstElementChild.src = smallImages[0].firstElementChild.src;

    for (let j = 0; j < smallImages.length; j++) {
      smallImages[j].addEventListener("mouseover", function (e) {
        if (e.target.tagName == "IMG") {
          var largeImage = e.target.parentElement.parentElement.getElementsByClassName("js-large-image")[0];
          largeImage.firstElementChild.src = e.target.src;
        }
      })
    }
  }
});
