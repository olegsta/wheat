app.controller('PositionsFormCtrl', ['$scope', 'Page', '$routeParams', '$position', '$rootScope', 'YandexMaps', function ($scope, Page, $routeParams, $position, $rootScope, YandexMaps) {
  var ctrl = this;
  ctrl.position = {
    trade_type_id: 1
  };


  Page.current = $routeParams.id ? 'positions' : 'positions_new'

  if ($routeParams.id) {
    $scope.isEdit = true;
    $position.get({id: $routeParams.id}, function (res) {
      ctrl.position = res.position;
    })
  } else {
    ctrl.save = function () {
      $position.save({position: ctrl.position}, function (res) {
        Page.goToPosition(res.id)
      })
    }
  }

  $scope.$on("$destroy", function(){
    mapListner();
    Page.isMap = false;
  });

  var mapListner = $rootScope.$on('map:build', function () {
    var marker = YandexMaps.drawMarkers(
      [{lng: 55.6964, lat: 37.5781}],
      {draggable: true}
    );

    var fillGeodata = function (coords) {
      ymaps.geocode(coords).then(function (res) {
        ctrl.position.city = res.geoObjects.get(0).properties.get('description');
        ctrl.position.address = res.geoObjects.get(0).properties.get('name');
        ctrl.position.lng = coords[0];
        ctrl.position.lat = coords[1];
        $scope.$apply()
      })
    }

    YandexMaps.map.events.add('click', function (e) {
      marker.geometry.setCoordinates(e.get('coords'))
      fillGeodata(e.get('coords'))
    });

    marker.events.add('dragend', function(e) {
      var thisPlacemark = e.get('target');
      var coords = thisPlacemark.geometry.getCoordinates();
      fillGeodata(coords);
    });

    $scope.$watch('ctrl.position', function (val) {
      if (val) {
        var position = _.omit(val, 'id'),
            coords = [val.lng, val.lat];

        marker.properties.set(YandexMaps.markerProperties(position));

        if (val.lng && val.lat) {
          marker.geometry.setCoordinates(coords);
          YandexMaps.map.setCenter(coords);
        }
      }
    }, true)
  });


}])