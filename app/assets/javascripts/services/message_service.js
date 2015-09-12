app.service('Message', ['Correspondence', '$message', function (Correspondence, $message) {
  var Message = this;

  Message.send = function () {
    if (Message.body.length) {
      Correspondence.active.messages.push({
        body: Message.body,
        user_id: gon.user.info.id,
        correspondence_id: Correspondence.active.id,
        created_at: new Date()
      })

      $message.save({body: Message.body, correspondence_id: Correspondence.active.id})
      Correspondence.scrollBottom();
      Message.body = "";
    }
  }
}])

app.factory('$message', ['$resource', function ($resource) {
  return $resource(Routes.message_path(":id"), {id: "@id"})
}])