"use strict"

app = angular.module "app.services"

app.service "ProgressOverlayService", [
    ->
        class ProgressOverlay
            constructor: ->
                @message = ""

            setMessage: (msg) ->
                console.log "MSG:", msg
                @message = msg

        new ProgressOverlay
]
