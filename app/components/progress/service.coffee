"use strict"

app = angular.module "app.services"

app.service "ProgressOverlayService", [
    ->
        class ProgressOverlay
            constructor: ->
                @message = ""

            setMessage: (msg) ->
                @message = msg

            resetMessage: ->
                @message = ""

        new ProgressOverlay
]
