app.service('Position', ['$http', function($http) {
  var Position = this;


  Position.search = function (params, fn) {
    $http.get('/positions/search', {params: params})
      .success(function (res) {
        fn(res.points)
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