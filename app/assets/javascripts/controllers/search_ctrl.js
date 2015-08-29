app.controller('SearchCtrl', ['$scope', '$rootScope', '$location', '$position', 'Page', 'YandexMaps', 'Search', function($scope, $rootScope, $location, $position, Page, YandexMaps, Search) {
  var ctrl = this;

  Page.isMap = true;
  Page.current = 'search';

  $scope.$on("$destroy", function(){
    mapListner();
    Page.isMap = false;
  });

  var mapListner = $rootScope.$on('map:build', function () {
    Search.all({}, function (points) {
      YandexMaps.drawMarkers(points, {short: true});
    })
  })

  $scope.$watch(function () {
    return $location.search().id
  }, function (id) {
    if (id) {
      ctrl.spinner = true;
      ctrl.modalOpened = true;
      Page.blur = true;
      $rootScope.overlay = true;
      $position.get({id: id}, function (res) {
        ctrl.active_position = res.position;
        ctrl.spinner = false;
      });
    } else {
      ctrl.spinner = false;
      ctrl.modalOpened = false;
      Page.blur = false;
      $rootScope.overlay = false;
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
        Search.position = {};
        YandexMaps.drawMarkers(points, {short: true});
      })
    }
  }, true)

  $scope.$watch(function () {
    return Search.query
  }, function (query) {
    if (query!=undefined)
      Search.all({query: query}, function (points) {
        YandexMaps.drawMarkers(points, {short: true});
      })
  })

  ctrl.closeModal = function () {
    $location.search({id: undefined})
  }

}]);