app.service('Message', ['Correspondence', '$http', function (Correspondence, $http) {
  var Message = this;

  Message.send = function () {
    if (Message.body.length) {
      Correspondence.active.messages.push({
        body: Message.body,
        user_id: gon.user.info.id,
        correspondence_id: Correspondence.active.id,
        created_at: new Date()
      })

      $http.put(Routes.correspondence_path(Correspondence.active.id), {body: Message.body})
      Correspondence.scrollBottom();
      Message.body = "";
    }
  }
}])