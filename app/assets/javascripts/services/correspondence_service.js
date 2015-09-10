app.service('Correspondence', ['$http', '$correspondence', '$location', '$timeout', function ($http, $correspondence, $location, $timeout) {
  var Correspondence = this;

  
  Correspondence.query = function () {
    $correspondence.query(function (res) {
      Correspondence.byTabs = _.groupBy(res, 'correspondence_type');
      Correspondence.tab = 'positions';
    })
  }

  Correspondence.get = function (id) {
    $correspondence.get({id: id}, function (res) {
      Correspondence.active = res.correspondence;
      Correspondence.scrollBottom();
    })
  }

  Correspondence.set = function (correspondence) {
    $location.search({tab: Correspondence.tab, id: correspondence.id});
  }

  Correspondence.scrollBottom = function () {
    $timeout(function () {
      var element = document.querySelector('.messages__body');
      if (element) {
        element.scrollTop = element.scrollHeight;
      }
    });
  }
}])

app.factory('$correspondence', ['$resource', function ($resource) {
  return $resource(Routes.correspondence_path(":id"), {id: "@id"})
}])