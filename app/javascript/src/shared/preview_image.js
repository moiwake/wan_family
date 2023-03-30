let fileInputs = document.getElementsByClassName("js-file-input");

for (let i = 0; i < fileInputs.length; i++) {
  fileInputs[i].addEventListener("change", function (e) {
    let img = document.getElementsByClassName("js-upload-image")[i];

    let fileReader = new FileReader();
    fileReader.onload = (function (e) {
      img.src = e.target.result;
    });

    fileReader.readAsDataURL(e.target.files[0]);
  });
}
