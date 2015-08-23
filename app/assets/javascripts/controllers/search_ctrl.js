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

  ctrl.closeModal = function () {
    $location.search({id: undefined})
  }

}]);