app.controller('SearchCtrl', ['$scope', '$rootScope', '$timeout', '$http', '$location', '$position', '$offer', 'Position', 'Page', 'YandexMaps', 'Search', function($scope, $rootScope, $timeout, $http, $location, $position, $offer, Position, Page, YandexMaps, Search) {
  var ctrl = this;

  Page.current = 'search';

  Search.resetForm();

  $scope.$on('$destroy', function () {
    visibilityPositionModal(false)
  })

  var mapListner = $scope.$on('map:build', function () {
    Search.all({}, function (points) {
      YandexMaps.drawMarkers(points, {short: true});
    })

    YandexMaps.map.events.add('click', function (e) {
      console.log(e.get('coords'))
    });

    YandexMaps.map.behaviors.events.add('dragstart', function (e) {
      Page.transparent = true;
      $scope.$apply();
    });

    YandexMaps.map.behaviors.events.add('dragend', function (e) {
      Page.transparent = false;
      $scope.$apply();
    });

    YandexMaps.map.events.add('boundschange', function (e) {
      Search.visible_count = ymaps.geoQuery(YandexMaps.geoObjects).searchIntersect(YandexMaps.map).getLength();
      $scope.$apply();
    });

  });

  $position.query({status: 'opened'}, function (res) {
    ctrl.myPositions = res;
  })

  ctrl.favorites = Position.favorites.query();

  $scope.$watch(function () {
    return $location.search().id
  }, function (id) {
    if (id) {
      visibilityPositionModal(true);
      $position.get({id: id, with_suitable: true}, function (res) {
        ctrl.active_position = res.position;
        ctrl.suit_positions = res.suit_positions;
        ctrl.spinner = false;
      });
    } else {
      visibilityPositionModal(false);
    }
  })

  $scope.$watch(function () {
    return Search.tags
  }, function (n_tags, o_tags) {
    if (n_tags.length || (n_tags.length == 0 && o_tags.length)) {
      params = {
        query: Search.query,
        filters: JSON.stringify(n_tags)
      }
      Search.all(params, function (points) {
        ctrl.isShowExtendedSearch = false;
        Search.resetForm();
        YandexMaps.drawMarkers(points, {short: true});
        YandexMaps.addCircleToMap(Search.circles);
      })
    }
  }, true)

  $scope.$watch(function () {
    return Search.checkedPosition
  }, function (checkedPosition) {
    if (checkedPosition != undefined) {
      var ids = window.pickTrue(checkedPosition);

      if (ids.length) {
        params = {
          'id[]': ids
        }
        
        Search.suitable(params, function (points) {
          YandexMaps.drawMarkers(points, {short: true});
          $timeout(function () {
            if (points.length)
              YandexMaps.map.setBounds(YandexMaps.map.geoObjects.getBounds());
          })
        })
      } else {
        Search.all(params, function (points) {
          ctrl.isShowExtendedSearch = false;
          Search.resetForm();
          YandexMaps.drawMarkers(points, {short: true});
          $timeout(function () {
            YandexMaps.addCircleToMap(Search.circles);
          })
        })
      }
    }
  }, true)

  ctrl.setActiveTag = function ($index) {
    ctrl.isShowExtendedSearch = true;
    Search.form = _.clone(Search.tags[$index]);
  }

  ctrl.sendOffer = function (position_id, offer_id) {
    $offer.save({position_id: position_id, offer_id: offer_id}, function (res) {
      visibilityPositionModal(false)
    })
  }

  $scope.$watch(function () {
    return Search.query
  }, function (query) {
    if (query!=undefined) {
      params = {
        query: Search.query,
        filters: JSON.stringify(Search.tags)
      }
      Search.all(params, function (points) {
        ctrl.isShowExtendedSearch = false;
        Search.resetForm();
        YandexMaps.drawMarkers(points, {short: true});
        YandexMaps.addCircleToMap(Search.circles);
      })
    }
  })

  ctrl.closeModal = function () {
    visibilityPositionModal(false)
  }

  var visibilityPositionModal = function (arg) {
    ctrl.spinner = arg;
    ctrl.modalOpened = arg;
    Page.blur = arg;
    $rootScope.overlay = arg;
    if (!arg)
      $location.search({id: undefined})
  }

}]);