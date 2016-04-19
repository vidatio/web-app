"use strict"

app = angular.module "app.services"

app.service "ProgressService", [
    "$timeout"
    "$rootScope"
    ($timeout, $rootScope) ->
        class Progress

            setMessage: (msg) ->
                $rootScope.progressMessage = msg

        new Progress
]
