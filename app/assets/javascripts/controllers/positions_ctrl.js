app.controller('PositionsCtrl', ['$scope', 'Page', 'Position', '$position', '$location', function ($scope, Page, Position, $position, $location) {
  var ctrl = this;
  ctrl.spinner = true;

  Page.current = 'positions';

  ctrl.tab = 0;


  $scope.$watch('ctrl.tab', function (id) {
    ctrl.positions = [];
    ctrl.spinner = true;

    var status = findById(gon.translation.position.statuses, id).name;
    $location.search({status: status});
    
    $position.query({status: status}, function (res) {
      ctrl.positions = res;
      ctrl.spinner = false;
    }, function () {
      ctrl.spinner = false;
    });
  })
}])