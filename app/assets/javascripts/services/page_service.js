app.service('Page', ['$location', function ($location) {
  var Page = this;

  Page.notMap = true;

  Page.goToPosition = function (id) {
    $location.url("/search").search({id: id})
  }

  Page.goToCreateSuitable = function (id) {
    $location.url("/positions/new").search({position_id: id})
  }
}])