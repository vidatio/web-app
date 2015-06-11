# fileReader Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "FileReadCtrl", [
    "$scope"
    "$http"
    "FileReader"
    ($scope, $http, FileReader) ->
        $scope.link = 'http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv'
        $scope.progress = 0

        $scope.load = ->
            url = $scope.link
            $http.get('http://localhost:3333/v0/upload', params: url: url).success (data) ->
                $scope.content = data


        $scope.getFile = ->
            $scope.progress = 0
            FileReader.readAsDataUrl($scope.file, $scope).then (result) ->
                $scope.content = result
            return
        return

        $scope.$on 'fileProgress', (ev, progress) ->
            $scope.progress = progres.loaded / progres.total
]
