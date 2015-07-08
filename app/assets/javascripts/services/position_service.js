app.service('Position', ['$resource', '$http', function($resource, $http) {
  var Position = this;

  var PositionResource = $resource('/positions/:id.json', {
    get: {method:'GET', params: {id: '@id'}},
    create: {method:'POST'},
    update: {method:'PUT', params: {id: '@id'}},
    destroy: {method:'DELETE', params: {id: '@id'}}
  });

  Position.search = function (params, fn) {
    $http.get('/positions/search', {params: params})
      .success(function (res) {
        fn(res.points)
      })
  }

  Position.get = PositionResource.get;
  Position.create = PositionResource.create;
  Position.update = PositionResource.update;
  Position.destroy = PositionResource.destroy;

}])