"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "DataFactory"
    "UserDatasetsFactory"
    "ProgressService"
    "DataService"
    "$cookieStore"
    "$log"
    "$translate"
    ($scope, DataFactory, UserDatasetsFactory, Progress, Data, $cookieStore, $log, $translate) ->
        $scope.vidatios = []

        globals = $cookieStore.get "globals" || {}

        UserDatasetsFactory.query {id: globals.currentUser.id}, (response) ->
            response.splice(0, response.length - 4)
            $scope.vidatios = response

            for vidatio in $scope.vidatios
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

        # @method $scope.createVidatio
        # @description creates Vidatio from saved Dataset
        $scope.openInEditor = (data) ->
            $log.info "DatasetCtrl $scope.createVidatio called"

            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.createVidatio data
]
