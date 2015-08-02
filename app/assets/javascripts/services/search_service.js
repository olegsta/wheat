app.service('Search', ['$http', function ($http) {
  var Search = this;

  Search.all = function (params, fn) {
    $http.get(Routes.search_path({format: 'json'}), {params: params})
      .success(function (res) {
        fn(res.positions)
      })
  }
}])