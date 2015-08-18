app.directive('fileread', ['$parse', function ($parse) {
  return {
    scope: {
      fileread: "=",
      src: "=src"
    },
    restrict: 'A',
    link: function($scope, element, attrs) {  

      element.bind('change', function(){
        $scope.fileread = element[0].files;
        $scope.$apply();

        element[0].value = '';
      });
    }
  };
}]);