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
    if (Search.form.id != undefined) {
      Search.tags[Search.form.id-1] = _.clone(Search.form);
    } else {
      var tag = _.clone(Search.form);

      tag.id = Search.tags.length + 1;
      Search.tags.push(tag);
    }
  }

  Search.resetForm = function () {
    Search.form = {
      currency_id: gon.user.currency.id
    }
  }
}])