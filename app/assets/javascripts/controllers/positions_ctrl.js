app.controller('PositionsCtrl', ['$scope', 'Page', 'Position', '$position', '$location', function ($scope, Page, Position, $position, $location) {
  var ctrl = this;
  ctrl.spinner = true;

  Page.checkForAuth();
  Page.current = 'positions';

  

  $scope.$watch(function () {
    return $location.search().status
  }, function (tab) {
    ctrl.tab = tab;
  })


  $scope.$watch('ctrl.tab', function (id) {
    if (id) {
      ctrl.spinner = true;
      ctrl.positions = undefined;

      var status = findById(gon.translation.position.statuses, id).id;
      $location.search({status: status});
      
      $position.query({status: status}, function (res) {
        ctrl.positions = res;
        ctrl.spinner = false;
      }, function () {
        ctrl.spinner = false;
      });
    }
  })
}])