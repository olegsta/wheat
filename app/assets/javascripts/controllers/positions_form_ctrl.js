app.controller('PositionsFormCtrl', ['$scope', 'Page', '$routeParams', '$position', '$rootScope', 'YandexMaps', function ($scope, Page, $routeParams, $position, $rootScope, YandexMaps) {
  var ctrl = this;
  ctrl.position = {
    trade_type_id: 1,
    images: [],
    files: []
  };

  Page.current = $routeParams.id ? 'positions' : 'positions_new'

  $scope.$on("$destroy", function(){
    mapListner();
    Page.isMap = false;
  });

  if ($routeParams.id) {
    $scope.isEdit = true;
    $position.get({id: $routeParams.id}, function (res) {
      ctrl.position = res.position;
    })

    ctrl.save = function () {
      $position.update({id: $routeParams.id}, buildFormData(ctrl.position), function (res) {
        Page.goToPosition(res.id)
      })
    }
  } else {
    ctrl.save = function () {
      $position.create(buildFormData(ctrl.position), function (res) {
        Page.goToPosition(res.id)
      })
    }
  }

  $scope.$watch('src', function (src) {
    _.each(src, function (url) {
      ctrl.position.images.push({url: url});
    })
  }, true)

  $scope.$watch('files', function (files) {
    _.each(files, function (file) {
      ctrl.position.files = ctrl.position.files || [];
      ctrl.position.files.push(file)
    })
  })

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

  function buildFormData(fields) {
    var fd = new FormData();

    _.each(fields, function (v, k) {
      if (_.isArray(v)) {
        _.each(v, function (el) {
          fd.append(k+"[]", el)
        });
      } else {
        fd.append(k, v)
      }
    })

    return fd;
  }
}])