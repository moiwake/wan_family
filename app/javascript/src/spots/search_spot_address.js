window.onload = function() {
  initMap();
}

let searchAddBtn = document.getElementsByClassName("js-search-address-btn")[0];
if( searchAddBtn !== null ) {
  searchAddBtn.addEventListener("click", searchAddress);
}

let map
function initMap(){
  geocoder = new google.maps.Geocoder()

  map = new google.maps.Map(document.getElementById("map-display"), {
    center:  {lat: 35.6803997, lng:139.7690174},
    zoom: 17,
  });
}

let marker
let aft
function searchAddress(){
  let searchWord = document.getElementsByClassName("js-spot-name-input")[0].value;

  geocoder = new google.maps.Geocoder()
  geocoder.geocode( { "address": searchWord }, function(results, status) {
    if (status == "OK") {
      let addressArray = results[0].formatted_address.split(" ");

      if (addressArray[1]){
        if (aft == true) {
          marker.setMap(null);
        }

        map.setCenter(results[0].geometry.location);
        marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
        });

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
