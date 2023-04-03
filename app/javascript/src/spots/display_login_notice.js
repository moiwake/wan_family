let markSpotBtns = document.getElementsByClassName("js-mark-spot-btns")[0];

if (markSpotBtns.dataset.login == "true") {
  let iconLink = markSpotBtns.querySelector("a");
  let notice = markSpotBtns.getElementsByClassName("js-login-notice")[0];

  iconLink.addEventListener("mouseover", function () {
    notice.classList.add("js-login-notice-open");
  });

  iconLink.addEventListener("mouseout", function () {
    notice.classList.remove("js-login-notice-open");
  });
}
