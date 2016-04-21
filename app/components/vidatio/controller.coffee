"use strict"

app = angular.module "app.controllers"

app.controller "VidatioCtrl", [
    "$scope"
    "$rootScope"
    "$translate"
    "ngToast"
    "$cookieStore"
    "ProgressService"
    "DataService"
    "DatasetFactory"
    "ErrorHandler"
    "$window"
    ($scope, $rootScope, $translate, ngToast, $cookieStore, Progress, Data, DatasetFactory, ErrorHandler, $window) ->
        $scope.locale = $rootScope.locale
        $scope.$watch "vidatio", ->
            return unless $scope.vidatio
            globals = $cookieStore.get "globals"
            if globals?
                $scope.authorized = globals.currentUser.id is $scope.vidatio.metaData.userId._id
            else
                $scope.authorized = false
        , true

        $scope.openInEditor = ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                $scope.useSavedData()

        $scope.deleteVidatio = ->

            bootbox.confirm $translate.instant("DATASET_DELETE_CONFIRMATION"), (result) ->
                return unless result

                DatasetFactory.delete {id: $scope.vidatio._id}, (data) ->
                    idx = $scope.$parent.vidatios.indexOf $scope.vidatio
                    $scope.$parent.vidatios.splice idx, 1
                    $translate("TOAST_MESSAGES.DATASET_DELETED")
                    .then (translation) ->
                        ngToast.create
                            content: translation
                , (error) ->
                    return ErrorHandler.format error

        $scope.useSavedData = ->
            Data.useSavedData $scope.vidatio


]
