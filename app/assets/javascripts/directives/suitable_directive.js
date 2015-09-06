app.directive('suitable', [function () {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=ngModel",
      positions: "=positions"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'suitable.html',
    replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.$watch('positions', function (positions) {
        if (positions && positions.length) {
          $scope.position = positions[0];
        }
      }, true)

      $scope.$watch('position', function (position) {
        if (position) {
          $scope.ngModel = position.id;
        }
      })

      iElm.bind('click', function ($event) {
        $event.stopPropagation();
      })

      angular.element(document.querySelector('body')).bind('click', function () {
        $scope.opened = false;
        $scope.$apply();
      })
    }
  };
}]);