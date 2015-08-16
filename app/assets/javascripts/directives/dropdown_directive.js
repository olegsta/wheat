app.directive('dropdown', [function(){
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      title: "=title",
      isOpened: "=isOpened"
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'dropdown.html',
    replace: true,
    transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      iElm.bind('click', function ($event) {
        $event.stopPropagation();
      })

      angular.element(document.querySelector('body')).bind('click', function () {
        $scope.isOpened = false;
        $scope.$apply();
      })
    }
  };
}]);