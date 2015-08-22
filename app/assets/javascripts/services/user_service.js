app.service('User', ['$http', '$rootScope', function ($http, $rootScope) {
  var User = this;

  User.signOut = function () {
    $http.delete(Routes.destroy_user_session_path())
      .success(function () {
        window.location = "/";
      })
  }

  User.signIn = function (form) {
    $http.post(Routes.user_session_path(), form)
      .success(function () {
        window.location.reload();
      })
  }

  User.signUp = function (form) {
    $http.post(Routes.user_registration_path(), form)
      .success(function () {
        window.location.reload();
      })
  }

  $rootScope.$watch(function () {
    return User.isShowSign
  }, function () {
    $rootScope.blurContent =  !!User.isShowSign;
    $rootScope.overlay = !!User.isShowSign;
  })
}])