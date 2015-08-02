app.config(['$httpProvider', '$locationProvider', function ($httpProvider, $locationProvider) {
  /*
   *  Set token for AngularJS ajax methods
  */
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name=csrf-token]').content;

  /*
   *  Enable HTML5 History API
  */
  $locationProvider.html5Mode(true).hashPrefix('!');
}]);