let search_button = document.getElementById("form_search_button");
if( search_button !== null ) {
  search_button.addEventListener("click", searchAddress);
}

let aft
function searchAddress(){
  let searchWord = document.getElementById("form_search_spot").value;

  geocoder = new google.maps.Geocoder()
  geocoder.geocode( { "address": searchWord }, function(results, status) {
    if (status == "OK") {
      let addressArray = results[0].formatted_address.split(" ");

      if (addressArray[1]){
        document.getElementById("form_spot_lat").value = results[0].geometry.location.lat();
        document.getElementById("form_spot_lng").value = results[0].geometry.location.lng();
        document.getElementById("form_spot_address").value = addressArray[1];

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
    document.getElementById("form_spot_lat").value = "";
    document.getElementById("form_spot_lng").value = "";
    document.getElementById("form_spot_address").value = "";
  }
}
