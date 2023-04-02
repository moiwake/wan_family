let fileInput = document.getElementsByClassName("js-file-input")[0];

fileInput.addEventListener("change", function (e) {
  let previewList = document.getElementById("js-preview-image-list");

  while (previewList.firstElementChild) {
    previewList.firstElementChild.remove();
    previewList.classList.remove("js-preview-display");
  }

  for (i = 0; i < e.target.files.length; i++) {
    let fileReader = new FileReader();
    fileReader.onload = (function (e) {
      let newListContent = document.createElement("li");
      newListContent.setAttribute("class", "js-preview-image");
      previewList.insertBefore(newListContent, previewList.firstElementChild);

      let img = new Image();
      img.src = e.target.result;

      document.getElementsByClassName("js-preview-image")[0].appendChild(img);
    });

    fileReader.readAsDataURL(e.target.files[i]);
  }
});
