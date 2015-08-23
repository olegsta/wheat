app.directive('afDimension', ['$rootScope', function($rootScope) {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      ngModel: "=ngModel",
      ngModelDimension: "=ngModelDimension",
      options: "=options",
      before: "=before",
      prefix: "=prefix"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'dimension.html',
    replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.uid = window.guid();

      $scope.toggle = function ($event) {
        if (!$scope.disabled) {
          var isShow = $scope.isShow;
          $rootScope.$broadcast('closePopup', {uid: $scope.uid});
          $rootScope.$on('closePopup', function (event, args) {
            if (args.uid!=$scope.uid)
              $scope.isShow = false;
          });
          $scope.isShow = !isShow;
          $event.stopPropagation();
        }
      }

      $scope.setActive = function (id) {
        $scope.ngModelDimension = id;
        $scope.currentOption = findById($scope.options, id).title;
        $scope.isShow = false;
      }

      $scope.$watchCollection('options', function (v) {
        if (v) {
          var id = _.isUndefined($scope.ngModelDimension) ? v[0].id : $scope.ngModelDimension;
          $scope.setActive(id)            
        }
      });

      $scope.$watch('ngModelDimension', function (id) {
        if (id)
          $scope.setActive(id)
      })

      angular.element(document.querySelector('body')).bind('click', function () {
        $scope.isShow = false;
        $scope.$apply();
      })
    }
  };
}]);