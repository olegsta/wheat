app.controller('OffersCtrl', ['$scope', 'Page', '$offer', function ($scope, Page, $offer) {
  var ctrl = this;

  Page.checkForAuth();
  Page.current = 'offers';
  
  ctrl.spinner = true;

  $offer.query({}, function (res) {
    ctrl.offers = res;
    ctrl.spinner = false;
  });
}])