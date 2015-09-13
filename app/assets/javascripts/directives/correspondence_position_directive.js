app.directive('correspondencePosition', ['Page', function (Page) {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    scope: {
      position: "=position",
      title: "=title",
      opened: "=opened",
    }, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    // restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    templateUrl: 'correspondence_position.html',
    replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      $scope.Page = Page;

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