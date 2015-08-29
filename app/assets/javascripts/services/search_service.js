app.service('Search', ['$http', function ($http) {
  var Search = this;

  Search.tags = [];

  Search.all = function (params, fn) {
    $http.get(Routes.search_path({format: 'json'}), {params: params})
      .success(function (res) {
        fn(res.positions)
      })
  }

  Search.addTag = function () {
    var tag = _.clone(Search.position);

    tag.id = Search.tags.length + 1;
    Search.tags.push(tag);
  }
}])