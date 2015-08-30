app.service('Position', ['$http', 'Action', function($http, Action) {
  var Position = this;


  Position.search = function (params, fn) {
    $http.get(Routes.search_path(), {params: params})
      .success(function (res) {
        fn(res.points)
      })
  }

  Position.deleteAttachment = function (id, callback) {
    Action.confirm({main: "Вы действительно хотите удалить файл?"}, function (confirmed) {
      if (confirmed) {
        $http.delete(Routes.attachments_path(), {params: {id: id}})
          .success(function () {
            callback();
          })
      }
    });
  }

  Position.toggleFavorite = function (position) {
    $http.put(Routes.favorites_positions_path(), {id: position.id})
      .success(function (res) {
        Position.favorites = res;
      })
  }
}])

app.factory('$position', ['$resource', function ($resource) {
  return $resource(Routes.position_path(':id', {format: 'json'}), {id: "@id"}, {
    get: {method:'GET', params: {id: '@id'}},
    create: {method: 'POST'},
    update: {method: 'PUT', params: {id: '@id'}},
    destroy: {method:'DELETE', params: {id: '@id'}}
  });
}])