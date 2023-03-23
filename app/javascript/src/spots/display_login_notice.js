let markSpotBtns = document.getElementsByClassName("js-mark-spot-btns")[0];
let icon_link = markSpotBtns.querySelector("a");
let notice = markSpotBtns.getElementsByClassName("js-login-notice")[0];

icon_link.addEventListener("mouseover", function () {
  notice.classList.add("js-open");
});

icon_link.addEventListener("mouseout", function () {
  notice.classList.remove("js-open");
});
