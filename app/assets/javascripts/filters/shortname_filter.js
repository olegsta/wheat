app.filter('shortname', [function(){
    return function(fullname) {
      var arr = fullname.split(" ");
      return [arr[0], arr[1][0]+'.', arr[2][0]+'.'].join(" ")
    };
}]);