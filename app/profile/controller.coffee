"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "UserDatasetsFactory"
    "$cookieStore"
    "$translate"
    "ErrorHandler"
    ($scope, UserDatasets, $cookieStore, $translate, ErrorHandler) ->
        $scope.vidatios = []
        globals = $cookieStore.get "globals" || {}

        $scope.$watch "vidatios", ->
            if $scope.vidatios.length < 4
                loadDatasets()
        , true

        loadDatasets = ->
            UserDatasets.datasetsLimit { "limit": 4 , id: globals.currentUser.id }, (response) ->
                $scope.vidatios = response
                for vidatio in $scope.vidatios
                    vidatio.image = if /(png|jpg)/.test(vidatio.visualizationOptions.thumbnail) then vidatio.visualizationOptions.thumbnail else "images/logo-greyscale.svg"
            , (error) ->
                ErrorHandler.format error

]
