app.config(['$routeProvider', function ($routeProvider) {  
  $routeProvider
    .when('/search', {
      templateUrl: Routes.search_path(),
      controller: 'SearchCtrl as ctrl',
      reloadOnSearch: false
    })
    .when('/positions/new', {
      templateUrl: Routes.new_position_path(),
      controller: 'PositionsFormCtrl as ctrl',
    })
    .when('/positions', {
      templateUrl: Routes.positions_path(),
      controller: 'PositionsCtrl as ctrl',
    })
    .when('/positions/:id/edit', {
      templateUrl: Routes.edit_position_path(0),
      controller: 'PositionsFormCtrl as ctrl',
    })
    .when('/messages', {
      templateUrl: Routes.messages_path(),
      controller: 'MessagesCtrl as ctrl',
    })
    .when('/analytics', {
      templateUrl: Routes.analytics_path(),
      controller: 'AnalyticsCtrl as ctrl',
    })
    .when('/help', {
      templateUrl: Routes.help_path(),
      controller: 'HelpCtrl as ctrl',
    })
    .when('/support', {
      templateUrl: Routes.support_path(),
      controller: 'SupportCtrl as ctrl',
    })
    .when('/profile', {
      templateUrl: Routes.profile_path(),
      controller: 'ProfileCtrl as ctrl',
    })
    .when('/settings', {
      templateUrl: Routes.settings_path(),
      controller: 'SettingsCtrl as ctrl',
    })
    .when('/offers', {
      templateUrl: Routes.offers_path(),
      controller: 'OffersCtrl as ctrl',
    })
    .otherwise({
      redirectTo: '/search'
    })
}]);