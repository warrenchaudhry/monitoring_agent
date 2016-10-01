jQuery(document).on 'turbolinks:load', ->
  App.alerts = App.cable.subscriptions.create "AlertsChannel",
    connected: ->


    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      toastr.warning(data.message)
