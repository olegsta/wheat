app.controller('OffersCtrl', ['$scope', 'Page', '$offer', function ($scope, Page, $offer) {
  var ctrl = this;

  Page.current = 'offers';

  ctrl.offers = $offer.query();
}])