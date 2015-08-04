app.controller('MessagesCtrl', ['$scope', 'Page', function ($scope, Page) {
  var messages = this;

  Page.current = 'messages';
}])