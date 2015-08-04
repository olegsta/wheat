app.controller('SearchCtrl', ['$scope', '$rootScope', 'Page', 'YandexMaps', 'Search', function($scope, $rootScope, Page, YandexMaps, Search) {
  var map = this;

  Page.isMap = true;
  Page.current = 'search';

  $scope.$on("$destroy", function(){
    mapListner();
    Page.isMap = false;
  });

  var mapListner = $rootScope.$on('map:build', function () {
    Search.all({}, function (points) {
      YandexMaps.drawMarkers(points);
    })
  })

}]);