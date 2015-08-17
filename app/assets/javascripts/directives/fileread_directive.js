app.directive('fileread', ['$parse', function ($parse) {
  return {
    scope: {
      fileread: "=",
      src: "=src"
    },
    restrict: 'A',
    link: function($scope, element, attrs) {  

      element.bind('change', function(){
        $scope.src = [];
        $scope.fileread = element[0].files;

        var index = 0;
        _.each($scope.fileread, function (f) {
          var reader = new FileReader();
          reader.onload = function (e) {
            $scope.src.push(e.target.result);

            console.log(index, $scope.fileread.length)
            if (index == $scope.fileread.length-1) {
              $scope.$apply();
            }
            index ++;
          }

          reader.readAsDataURL(f);
        })

        $scope.$apply()
      });
    }
  };
}]);