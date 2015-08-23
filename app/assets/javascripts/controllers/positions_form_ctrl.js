app.controller('PositionsFormCtrl', ['$scope', '$http', 'Page', '$routeParams', '$position', '$rootScope', 'YandexMaps', 'Position', function ($scope, $http, Page, $routeParams, $position, $rootScope, YandexMaps, Position) {
  var ctrl = this;
  ctrl.position = {
    trade_type_id: 1,
    attachments: [],
    currency_id: gon.user.currency.id
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
      $position.update({id: $routeParams.id}, {position: ctrl.position}, function (res) {
        Page.goToPosition(res.id)
      })
    }
  } else {
    ctrl.save = function () {
      $position.create({position: ctrl.position}, function (res) {
        Page.goToPosition(res.id)
      })
    }

    $http.get(Routes.templates_path())
      .success(function (res) {
        ctrl.templates = res.templates;
      })

    ctrl.setTemplate = function (position) {
      ctrl.is_show_template = false;
      ctrl.position = position;
    }
  }

  $scope.$watch('files', function (files) {
    if (files && files.length) {
      var fd = new FormData();

      _.each(files, function (file) {
        fd.append("attachments[]", file);
      })

      $http.post(Routes.attachments_path(), fd, {headers: {'Content-Type': undefined}})
        .success(function (res) {
          _.each(res.attachments, function (attachment) {
            ctrl.position.attachments = ctrl.position.attachments || [];
            ctrl.position.attachments.push(attachment);
          });

          $scope.files = []
        })
    }
  })

  ctrl.deleteAttachment = function (id, $index, $event) {
    $event.preventDefault();
    Position.deleteAttachment(id, function () {
      ctrl.position.attachments.splice($index, 1);
    })
    $event.stopPropagation();
    return false;
  }


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
    }, true);
  });
}])