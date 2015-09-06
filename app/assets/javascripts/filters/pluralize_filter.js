app.filter('plur', ['$sce', 'pluralize', function($sce, pluralize){
    return function(count, variants) {
      return pluralize(count, variants);
    };
}]);