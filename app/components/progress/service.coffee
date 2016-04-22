"use strict"

app = angular.module "app.services"

app.service "ProgressService", [
    "$rootScope"
    ($rootScope) ->
        class Progress

            setMessage: (msg) ->
                $rootScope.progressMessage = msg

            resetMessage: ->
                $rootScope.progressMessage = ""

        new Progress
]
