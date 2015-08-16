app.controller('SearchCtrl', ['$scope', '$rootScope', '$location', 'Page', 'YandexMaps', 'Search', function($scope, $rootScope, $location, Page, YandexMaps, Search) {
  var map = this;

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
      // alert("Модальное окно позиции " + id)
    }
  })

}]);