let inputFile = document.getElementById("form_review_image")

inputFile.addEventListener("change", function (e) {
  let previewLists = document.getElementById("preview_lists");
  let newPreview = document.createElement("li");

  previewLists.querySelector("li").remove();
  newPreview.setAttribute("id","preview");
  previewLists.insertBefore(newPreview, previewLists.firstChild);

  previewLists.classList.remove("preview-lists-display");

  for (i = 0; i < e.target.files.length; i++) {
    let fileReader = new FileReader();
    fileReader.onload = (function (e) {
        let img = new Image();
        img.src = e.target.result;
        document.getElementById("preview").appendChild(img);
    });

    fileReader.readAsDataURL(e.target.files[i]);
  }
});
