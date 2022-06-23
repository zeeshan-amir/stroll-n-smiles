$(() ->
  App.messages = App.cable.subscriptions.create { channel: 'MessagesChannel', id: $("#conversation_id").val() },
    received: (data) ->
      if data.action == "destroy"
        $("#m" + data.id).remove()
      else
        $("#new_message")[0].reset()
        $("#chat").prepend(data.message)

      if data.user_id != $("#user_id").val()
        $("#m" + data.id + " > div > a").remove()
)
