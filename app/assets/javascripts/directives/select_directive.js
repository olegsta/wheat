app.directive('afSelect', ['$timeout', function($timeout) {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=ngModel",
      options: "=options"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'select.html',
    // replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.toggle = function ($event) {
        $scope.isShow = !$scope.isShow;
      }

      $scope.setActive = function (id) {
        $scope.ngModel = id;
        $scope.currentOption = findById($scope.options, id).title;
        $scope.isShow = false;
      }

      $scope.$watchCollection('options', function (v) {
        if (v) {
          var id = _.isUndefined($scope.ngModel) ? v[0].id : $scope.ngModel;
          $scope.setActive(id)
        }
      });

      $scope.$watch('ngModel', function (id) {
        $scope.setActive(id);
      })

      iElm
        .bind('click', function (event) {
          event.stopPropagation();
        })
        .bind('mouseleave', function (event) {
          self.timeout = $timeout(function () {
            $scope.isShow = false;
            $scope.$apply();
          }, 500)
        })
        .bind('mousemove', function (event) {
          $timeout.cancel(self.timeout)
        })
    }
  };
}]);