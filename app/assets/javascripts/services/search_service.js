app.service('Search', ['$http', 'ngNotify', function ($http, ngNotify) {
  var Search = this;

  Search.tags = [];

  Search.all = function (params, fn) {
    $http.get(Routes.search_path({format: 'json'}), {params: params})
      .success(function (res) {
        fn(res)
      })
  }

  Search.addTag = function () {
    if (!Search.form.option_id && !Search.form.trade_type_id && !Search.form.city && !Search.form.radius && !Search.form.weight_from && !Search.form.weight_to && !Search.form.price_from && !Search.form.price_to ){
      ngNotify.set('Нельзя выполнить пустой запрос', 'error');
      return false;
    }


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