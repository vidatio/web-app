# Import Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ImportCtrl", [
    "$scope"
    "$http"
    "ImportService"
    "TableService"
    ($scope, $http, FileReader, DataTable) ->
        $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv"
        $scope.progress = FileReader.progress

        # Read via link
        $scope.load = ->
            url = $scope.link
            $http.get("/api"
                params:
                    url: url
            ).success (data) ->
               DataTable.setDataset data

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            FileReader.readAsDataUrl($scope.file, $scope).then (result) ->
               DataTable.setDataset result
]
