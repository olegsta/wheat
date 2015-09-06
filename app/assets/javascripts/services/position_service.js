app.service('Position', ['$http', '$resource', 'Action', function($http, $resource, Action) {
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

  Position.sendOffer = function (position_id, offer_id) {
    $http.post(Routes.send_offer_positions_path(), {position_id: position_id, offer_id: offer_id})
      .success(function (res) {
        // body...
      })
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
    destroy: {method:'DELETE', params: {id: '@id'}}
  });
}])