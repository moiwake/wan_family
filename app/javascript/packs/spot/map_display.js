let geocoder
let map
function initMap(){
  geocoder = new google.maps.Geocoder()

  map = new google.maps.Map(document.getElementById("map_display"), {
    center:  {lat: 35.6803997, lng:139.7690174},
    zoom: 17,
  });
}

window.onload = function() {
  initMap();
}

function docInit(){
  if (aft == true){
    document.getElementById("form_lat").value = "";
    document.getElementById("form_lng").value = "";
    document.getElementById("form_spot_address").value = "";
    marker.setMap(null);
  }
}

let aft
let marker
function codeAddress(){
  let inputAddress = document.getElementById("form_search_spot").value;
  geocoder.geocode( { "address": inputAddress }, function(results, status) {
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

        document.getElementById("form_lat").value = results[0].geometry.location.lat();
        document.getElementById("form_lng").value = results[0].geometry.location.lng();
        document.getElementById("form_spot_address").value = addressArray[1];

        aft = true;
      } else{
        alert("スポットを特定できませんでした。検索ワードを変更してください。");
        docInit();
      }
    } else {
      if(!inputAddress){
        alert("検索ワードを入力してください。");
      } else {
        alert("該当するスポットがありませんでした。");
      }
      docInit();
    }
  });
}

let search_button = document.getElementById("form_search_button");
if( search_button !== null ) {
  search_button.addEventListener("click", codeAddress);
}
