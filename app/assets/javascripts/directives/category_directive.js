app.directive('category', [function () {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=ngModel"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'category.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.gon = gon;

      $scope.$watch('ngModel', function (val) {
        $scope._ngModel = val;
      })

      $scope.$watch('isOpened', function () {
        $scope._ngModel = $scope.ngModel;
      })
      
      $scope.setOption = function (option) {
        $scope._ngModel = option.id;
      }

      $scope.apply = function () {
        $scope.ngModel = $scope._ngModel;
        $scope.isOpened = false;
      }
    }
  };
}]);