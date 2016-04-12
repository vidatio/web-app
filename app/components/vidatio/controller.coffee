"use strict"

app = angular.module "app.controllers"

app.controller "VidatioOverviewCtrl", [
    "$scope"
    "$translate"
    "ngToast"
    "$cookieStore"
    "ProgressService"
    "DataService"
    "DatasetFactory"
    "ErrorHandler"
    ($scope, $translate, ngToast, $cookieStore, Progress, Data, DatasetFactory, ErrorHandler) ->
        $scope.$watch "vidatio", ->
            return unless $scope.vidatio
            globals = $cookieStore.get "globals"
            $scope.authorized = globals.currentUser.id is $scope.vidatio.metaData.userId._id
        , true

        # @method $scope.openInEditor
        # @description set the vidatio options from saved dataset
        $scope.openInEditor = ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData $scope.vidatio

        $scope.deleteVidatio = ->
            DatasetFactory.delete {id: $scope.vidatio._id}, (data) ->
                idx = $scope.$parent.vidatios.indexOf $scope.vidatio
                $scope.$parent.vidatios.splice idx, 1
                # success deleting dataset
                # $translate("")
                # .then (translation) ->
                #     ngToast.create
                #         content: translation
            , (error) ->
                return ErrorHandler.format error

]
