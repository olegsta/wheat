app.filter('shortname', [function(){
    return function(fullname) {
      var arr = fullname.split(" ");
      if (arr.length >= 3)
        return [arr[0], arr[1][0]+'.', arr[2][0]+'.'].join(" ")
      else
        return fullname
    };
}]);