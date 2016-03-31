"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "DatasetFactory"
    "UserDatasetsFactory"
    "ProgressService"
    "DataService"
    "$cookieStore"
    "$translate"
    ($scope, DatasetFactory, UserDatasets, Progress, Data, $cookieStore, $translate) ->
        $scope.vidatios = []
        globals = $cookieStore.get "globals" || {}

        UserDatasets.query {id: globals.currentUser.id}, (response) ->
            response.splice(0, response.length - 4)
            $scope.vidatios = response

            for vidatio in $scope.vidatios
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

        # @method $scope.openInEditor
        # @description open dataset in Editor
        $scope.openInEditor = (data) ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData data
]
