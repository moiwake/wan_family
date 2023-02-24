let map
function initMap() {
  map = new google.maps.Map(document.getElementById('map_search_spot'), {
    center: new google.maps.LatLng(36.5, 137.0),
    zoom: 5.3,
  });

  let transitLayer = new google.maps.TransitLayer();
  transitLayer.setMap(map);

  let spotCounts = document.getElementById("spot_counts").value
  for (let i = 0; i < spotCounts; i++) {
    if (spotCounts) {
      let spotLatitude = Number(document.getElementById("spot_latitude_" + i).value);
      let spotLongitude = Number(document.getElementById("spot_longitude_" + i).value);
      let spotName = document.getElementById("spot_name_" + i).value;
      let spotPath = document.getElementById("spot_path_" + i).value;

      (function() {
        let markerLatLng = new google.maps.LatLng({lat: spotLatitude, lng: spotLongitude});
        let marker = new google.maps.Marker({
          position: markerLatLng,
          map: map
        });

        let infowindow = new google.maps.InfoWindow({
          position: markerLatLng,
          content: `<a href=${spotPath} target="_blank" rel="noopener noreferrer">${spotName}</a>`
        });
        marker.addListener('click', function() {
          infowindow.open(map, marker);
        });
      })();
    }
  }
}

window.onload = function() {
  initMap();
}

// 指定エリアにフォーカスする
function areaMap(lat, lng, zoom) {
  map.setCenter(new google.maps.LatLng(lat, lng));
  map.setZoom(zoom);
}

document.getElementById("hokkaido").addEventListener('click', function() {
  areaMap(43.2203266, 142.8634737, 7.2);
});

document.getElementById("tohoku").addEventListener('click', function() {
  areaMap(39.2362124, 141.1499861, 7.2);
});

document.getElementById("kanto").addEventListener('click', function() {
  areaMap(35.8598667, 139.6911374, 8.3);
});

document.getElementById("chubu").addEventListener('click', function() {
  areaMap(36.1543941, 137.9218204, 8);
});

document.getElementById("kinki").addEventListener('click', function() {
  areaMap(34.6413394, 135.562902, 8.3);
});

document.getElementById("chugoku").addEventListener('click', function() {
  areaMap(34.6823408, 132.5194897, 8.7);
});

document.getElementById("shikoku").addEventListener('click', function() {
  areaMap(33.5432238, 133.6375314, 8.8);
});

document.getElementById("kyushu").addEventListener('click', function() {
  areaMap(32.09, 130.8 ,7.6);
});

document.getElementById("okinawa").addEventListener('click', function() {
  areaMap(26.1201911, 127.7025012, 7.3);
});
