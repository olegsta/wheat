app.controller('SearchCtrl', ['$scope', 'Page', function($scope, Page) {
  var map = this;

  Page.isMap = true;

  $scope.$on("$destroy", function(){
    Page.isMap = false;
  });
}]);