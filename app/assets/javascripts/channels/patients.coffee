App.patients = App.cable.subscriptions.create "PatientsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    document.getElementsByClassName("patients")[0].innerHTML = data.html

