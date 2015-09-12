app.controller('ProfileCtrl', ['$scope', 'Page', '$user', '$routeParams', function ($scope, Page, $user, $routeParams) {
  var ctrl = this;

  Page.current = 'profile';
  Page.checkForAuth();

  if ($routeParams.id) {
    ctrl.user = $user.get({id: $routeParams.id});
  } else {
    ctrl.user = gon.user.info;
  }
}])