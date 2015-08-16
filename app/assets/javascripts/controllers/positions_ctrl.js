app.controller('PositionsCtrl', ['$scope', 'Page', 'Position', '$position', function ($scope, Page, Position, $position) {
  var ctrl = this;

  Page.current = 'positions';

  ctrl.tab = 1;

  $position.get(function (res) {
    ctrl.positions = res.positions;
  });
}])