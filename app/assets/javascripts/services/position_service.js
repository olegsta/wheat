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
    create: {method: 'POST', transformRequest: angular.identity, headers: {'Content-Type': undefined}},
    update: {method: 'PUT', params: {id: '@id'}, transformRequest: angular.identity, headers: {'Content-Type': undefined}},
    destroy: {method:'DELETE', params: {id: '@id'}}
  });
}])