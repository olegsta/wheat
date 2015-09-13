app.controller('MessagesCtrl', ['$scope', 'Page', '$http', '$location', 'Message', 'Correspondence', function ($scope, Page, $http, $location, Message, Correspondence) {
  var ctrl = this;

  Page.current = 'messages';
  Page.checkForAuth();
  
  Correspondence.query();
  Correspondence.scrollBottom();

  $scope.$watch(function () {
    return Correspondence.tab
  }, function (tab) {
    if (tab && Correspondence.byTabs) {
      Correspondence.tabPane = Correspondence.byTabs[tab] || [];
    }
  })

  $scope.$watch(function () {
    return $location.search().id
  }, function (id) {
    if (id) {
      Correspondence.get(id)
    }
  });

  angular.element(document.querySelector('textarea.message__textarea')).bind('keydown', function (e) {
    if ((e.metaKey || e.ctrlKey) && e.keyCode == 13) {
      Message.send(Message.body);
      $scope.$apply();
    }
  });
}])