"use strict"

app = angular.module "app.services"

app.service "ProgressService", [
    ->
        class Progress

            _message = null

            constructor: ->
                _message = ""

            getMessage: ->
                _message

            setMessage: (msg) ->
                _message = msg

        new Progress
]
