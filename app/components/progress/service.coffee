"use strict"

app = angular.module "app.services"

app.service "ProgressOverlayService", [
    ->
        class ProgressOverlay

            _message = null

            constructor: ->
                _message = ""

            getMessage: ->
                _message

            setMessage: (msg) ->
                _message = msg

        new ProgressOverlay
]
