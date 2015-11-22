"use strict"

app = angular.module "app.services"

app.service "ProgressOverlayService", [
    "$log"
    ($log) ->
        class ProgressOverlay

            _message = null

            constructor: ->
                _message = ""

            getMessage: ->
                _message

            setMessage: (msg) ->
                $log.info "ProgressOverlay setMessage function called"
                $log.debug
                    message: msg
                _message = msg

        new ProgressOverlay
]
