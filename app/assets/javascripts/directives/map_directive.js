app.directive('map', ['YandexMaps', 'Search', '$timeout', '$rootScope', function(YandexMaps, Search, $timeout, $rootScope) {
  // Runs during compile
  return {
    // name: '',
    // priority: 1,
    // terminal: true,
    // scope: {}, // {} = isolate, true = child, false/undefined = no change
    // controller: function($scope, $element, $attrs, $transclude) {},
    // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
    restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
    // template: '',
    // templateUrl: '',
    replace: true,
    // transclude: true,
    // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
    link: function($scope, iElm, iAttrs, controller) {
      ymaps.ready(function () {
        $timeout(function () {
          YandexMaps.create(iAttrs['id']);
          $rootScope.$broadcast('map:build')
        }, 300)
      })
    }
  };
}]);