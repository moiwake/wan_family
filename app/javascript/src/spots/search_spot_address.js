let searchAddBtn = document.getElementsByClassName("js-search-address-btn")[0];
if( searchAddBtn !== null ) {
  searchAddBtn.addEventListener("click", searchAddress);
}

let aft
function searchAddress(){
  let searchWord = document.getElementsByClassName("js-spot-name-input")[0].value;

  geocoder = new google.maps.Geocoder()
  geocoder.geocode( { "address": searchWord }, function(results, status) {
    if (status == "OK") {
      let addressArray = results[0].formatted_address.split(" ");

      if (addressArray[1]){
        document.getElementsByClassName("js-spot-lat-input")[0].value = results[0].geometry.location.lat();
        document.getElementsByClassName("js-spot-lng-input")[0].value = results[0].geometry.location.lng();
        document.getElementsByClassName("js-spot-address-input")[0].value = addressArray[1];

        aft = true;
      } else{
        alert("スポットを特定できませんでした。検索ワードを変更してください。");
      }
    } else {
      if(!searchWord){
        alert("検索ワードを入力してください。");
      } else {
        alert("該当するスポットがありませんでした。");
      }
    }
  });

  resetAddress();
}

function resetAddress(){
  if (aft == true){
    document.getElementsByClassName("js-spot-lat-input")[0].value = "";
    document.getElementsByClassName("js-spot-lng-input")[0].value = "";
    document.getElementsByClassName("js-spot-address-input")[0].value = "";
  }
}
