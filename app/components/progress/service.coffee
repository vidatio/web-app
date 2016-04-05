"use strict"

app = angular.module "app.services"

app.service "ProgressService", [
    "$timeout"
    ($timeout) ->
        class Progress

            _message = null

            constructor: ->
                _message = ""

            getMessage: ->
                _message

            setMessage: (msg) ->
                $timeout ->
                    _message = msg

        new Progress
]
