"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "UserDatasetsFactory"
    "ProgressService"
    "DataService"
    "$cookieStore"
    "$translate"
    "$log"
    ($scope, UserDatasets, Progress, Data, $cookieStore, $translate, $log) ->
        $scope.vidatios = []
        globals = $cookieStore.get "globals" || {}
        
        UserDatasets.datasetsLimit { "limit": 4 , id: globals.currentUser.id }, (response) ->
            $scope.vidatios = response
            for vidatio in $scope.vidatios
                vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"

        , (error) ->
            $log.info "ProfileCtrl error on query users' latest datasets"
            $log.error error

        # @method $scope.openInEditor
        # @description open dataset in Editor
        $scope.openInEditor = (data) ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData data
]
