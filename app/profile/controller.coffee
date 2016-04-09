"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "UserDatasetsFactory"
    "ProgressService"
    "DataService"
    "$cookieStore"
    "$translate"
    ($scope, UserDatasets, Progress, Data, $cookieStore, $translate) ->
        $scope.vidatios = []
        globals = $cookieStore.get "globals" || {}

        UserDatasets.query {id: globals.currentUser.id}, (response) ->
            $scope.vidatios = response.splice 0, 4
            for vidatio in $scope.vidatios
                vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"

        # @method $scope.openInEditor
        # @description open dataset in Editor
        $scope.openInEditor = (data) ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData data
]
