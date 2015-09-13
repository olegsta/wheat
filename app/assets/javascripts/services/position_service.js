app.service('Position', ['$http', '$resource', '$position', 'Action', function($http, $resource, $position, Action) {
  var Position = this;


  Position.search = function (params, fn) {
    $http.get(Routes.search_path(), {params: params})
      .success(function (res) {
        fn(res.points)
      })
  }

  Position.close = function (id, callback) {
    Action.confirm({main: "Вы действительно хотите переместить позицию в архив?"}, function (confirmed) {
      if (confirmed) {
        $position.delete({id: id}, function () {
          callback();
        })
      }
    });
  }

  Position.restore = function (id, callback) {
    Action.confirm({main: "Вы действительно хотите восстановить позицию в рынок?"}, function (confirmed) {
      if (confirmed) {
        $position.restore({id: id}, function () {
          callback();
        })
      }
    });
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

  Position.favorites = $resource(Routes.favorite_path(':id', {format: 'json'}), {id: '@id'}, {
    toggle: {method: 'PUT', params: {id: '@id'}, isArray: true}
  })
}])

app.factory('$position', ['$resource', function ($resource) {
  return $resource(Routes.position_path(':id', {format: 'json'}), {id: "@id"}, {
    get: {method:'GET', params: {id: '@id'}},
    create: {method: 'POST'},
    update: {method: 'PUT', params: {id: '@id'}},
    destroy: {method:'DELETE', params: {id: '@id'}},
    restore: {method: 'PUT', params: {id: 'restore'}}
  });
}])

app.factory('$offer', ['$resource', function ($resource) {
  return $resource(Routes.offer_path(':id', {format: 'json'}), {id: "@id"}, {
    get: {method:'GET', params: {id: '@id'}},
    create: {method: 'POST'},
    update: {method: 'PUT', params: {id: '@id'}},
    destroy: {method:'DELETE', params: {id: '@id'}}
  });
}])