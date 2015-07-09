# Import Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ImportCtrl", [
    "$scope"
    "$http"
    "ImportService"
    "TableService"
    ($scope, $http, Import, Table) ->
        $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv"
        $scope.progress = Import.progress

        # Read via link
        $scope.load = ->
            url = $scope.link
            $http.get("/v0/import"
                params:
                    url: url
            ).success (data) ->
                Table.setDataset data

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            Import.readFile($scope.file, $scope).then (result) ->
                Table.setDataset result
]
