app.directive('suggest', [function () {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=ngModel",
      coords: "=coords"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    // templateUrl: '',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      ymaps.ready(function () {
        window.suggestView = new ymaps.SuggestView(iElm[0]);
        suggestView.events.add('select', function (e) {
          $scope.ngModel = iElm[0].value;

          if ($scope.ngModel) {
            ymaps.geocode($scope.ngModel).then(function (res) {
              $scope.coords = res.geoObjects.get(0).geometry.getCoordinates();
              $scope.$apply();
            });
          } else {
            $scope.coords = undefined;
          }

          $scope.$apply();
        });

        $scope.$watch('ngModel', function (model) {
          if (!model) {
            $scope.coords = undefined;
          }
        })
      });
    }
  };
}]);