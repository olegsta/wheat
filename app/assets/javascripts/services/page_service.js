app.service('Page', ['$location', 'User', function ($location, User) {
  var Page = this;

  Page.notMap = true;

  Page.goToPosition = function (id) {
    $location.url("/search").search({id: id})
  }

  Page.goToEditPosition = function (id) {
    $location.url("/positions/" + id + "/edit")
  }

  Page.goToCreateSuitable = function (id) {
    $location.url("/positions/new").search({position_id: id})
  }

  Page.checkForAuth = function ($event) {
    if (!gon.user.data) {
      $location.url('/search');
      User.isShowSign = 'in';
      if ($event) {
        $event.stopPropagation();
        $event.preventDefault();
      }
    }
  }
}])