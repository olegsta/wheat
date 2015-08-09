app.config(['$routeProvider', function ($routeProvider) {  
  $routeProvider
    .when('/', {
      templateUrl: Routes.search_path(),
      controller: 'SearchCtrl as search',
    })
    .when('/positions/new', {
      templateUrl: Routes.new_position_path(),
      controller: 'PositionsNewCtrl as positions_new',
    })
    .when('/positions', {
      templateUrl: Routes.positions_path(),
      controller: 'PositionsCtrl as positions',
    })
    .when('/messages', {
      templateUrl: Routes.messages_path(),
      controller: 'MessagesCtrl as messages',
    })
    .when('/analytics', {
      templateUrl: Routes.analytics_path(),
      controller: 'AnalyticsCtrl as positions',
    })
    .when('/help', {
      templateUrl: Routes.help_path(),
      controller: 'HelpCtrl as positions',
    })
    .when('/support', {
      templateUrl: Routes.support_path(),
      controller: 'SupportCtrl as support',
    })
    .when('/profile', {
      templateUrl: Routes.profile_path(),
      controller: 'ProfileCtrl as profile',
    })
    .when('/settings', {
      templateUrl: Routes.settings_path(),
      controller: 'SettingsCtrl as settings',
    })
    .when('/offers', {
      templateUrl: Routes.offers_path(),
      controller: 'OffersCtrl as offers',
    })
    .otherwise({
      redirectTo: '/'
    })
}]);