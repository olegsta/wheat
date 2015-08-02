app.config(['$routeProvider', function ($routeProvider) {  
  $routeProvider
    .when('/', {
      templateUrl: Routes.search_path(),
      controller: 'SearchCtrl as search',
    })
    .when('/positions', {
      templateUrl: Routes.positions_path(),
      controller: 'PositionsCtrl as positions',
    })
    .otherwise({
      redirectTo: '/'
    })
}]);