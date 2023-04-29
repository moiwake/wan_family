window.onload = function() {
  initMap();
}

let map
function initMap() {
  map = new google.maps.Map(document.getElementById("js-map-display"), {
    center: new google.maps.LatLng(36.8, 137.0),
    zoom: 5.0,
  });

  let transitLayer = new google.maps.TransitLayer();
  transitLayer.setMap(map);

  moveFocusArea();
  markSpot();
}

let infoWindows = []
function markSpot() {
  let spots = document.getElementsByClassName("js-spot-data");

  for (let i = 0; i < spots.length; i++) {
    if (spots) {
      let spotLat = Number(spots[i].dataset.lat);
      let spotLng = Number(spots[i].dataset.lng);
      let spotName = spots[i].dataset.name;
      let spotAddress = spots[i].dataset.address;
      let spotCategory = spots[i].dataset.category;
      let spotPath = spots[i].dataset.path;

      (function() {
        let markerLatLng = new google.maps.LatLng({lat: spotLat, lng: spotLng});
        let marker = new google.maps.Marker({
          position: markerLatLng,
          map: map
        });

        let infoContent = "<div class='map-info'>"
        + `<a href=${spotPath} target="_blank" rel="noopener noreferrer">${spotName}</a>`
        + `<span>${spotAddress} / ${spotCategory}</span>`
        + "</div>";

        let infoWindow = new google.maps.InfoWindow({
          position: markerLatLng,
          content: infoContent
        });

        infoWindows.push(infoWindow);

        marker.addListener('click', function() {
          infoWindow.open(map, marker);
          infoClose(infoWindow);
        });
      })();
    }
  }
}

function infoClose(infoWindow) {
  if (document.getElementsByClassName("map-info").length > 0) {
    for (let j = 0; j < infoWindows.length; j++) {
      if (infoWindows[j] != infoWindow) {
        infoWindows[j].close();
      }
    }
  }
}

// 指定エリアにフォーカスする
function moveFocusArea() {
  let focusArea = document.getElementById("js-focus-area");
  if (focusArea.dataset.focus) {
    let funcName = focusArea.dataset.focus
    focusFunc[funcName]();
  }
}

let focusFunc = {
  "hokkaido": function () { areaMap(43.3203266, 142.8634737, 7.0); },
  "tohoku" : function () { areaMap(39.2362124, 141.1499861, 7.0); },
  "kanto" : function () { areaMap(35.8598667, 139.6911374, 8.0); },
  "chubu" : function () { areaMap(36.1543941, 138.8018204, 7.0); },
  "kinki" : function () { areaMap(34.6413394, 135.562902, 8.0); },
  "chugoku" : function () { areaMap(34.6823408, 132.5194897, 8.0); },
  "shikoku" : function () { areaMap(33.5432238, 133.5375314, 9.0); },
  "kyushu" : function () { areaMap(32.20, 130.8 ,8.0); },
  "okinawa" : function () { areaMap(26.1201911, 127.7025012, 7.0); }
}

document.getElementById("js-hokkaido-btn").addEventListener('click', focusFunc.hokkaido);
document.getElementById("js-tohoku-btn").addEventListener('click', focusFunc.tohoku);
document.getElementById("js-kanto-btn").addEventListener('click', focusFunc.kanto);
document.getElementById("js-chubu-btn").addEventListener('click', focusFunc.chubu);
document.getElementById("js-kinki-btn").addEventListener('click', focusFunc.kinki);
document.getElementById("js-chugoku-btn").addEventListener('click', focusFunc.chugoku);
document.getElementById("js-shikoku-btn").addEventListener('click', focusFunc.shikoku);
document.getElementById("js-kyushu-btn").addEventListener('click', focusFunc.kyushu);
document.getElementById("js-okinawa-btn").addEventListener('click', focusFunc.okinawa);

function areaMap(lat, lng, zoom) {
  map.setCenter(new google.maps.LatLng(lat, lng));
  map.setZoom(zoom);
}
