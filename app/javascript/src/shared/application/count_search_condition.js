addEventListener("DOMContentLoaded", function () {
  let searchFilterWrap = document.getElementsByClassName("js-search-filter-wrap")[0];

  let checkedOpts = searchFilterWrap.querySelectorAll("[checked]");
  let selectedOpts = searchFilterWrap.querySelectorAll("[selected]");

  let checkedOptNum = checkedOpts.length;
  let selectedOptsNum = selectedOpts.length;

  document.getElementsByClassName("js-search-condition-num")[0].dataset.num = checkedOptNum + selectedOptsNum;
});
