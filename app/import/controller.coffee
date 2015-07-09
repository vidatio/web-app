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
        $scope.progress = FileReader.progress

        # Read via link
        $scope.load = ->
            url = $scope.link
            $http.get("http://localhost:9876/v0/import"
                params:
                    url: url
            ).success (data) ->
                Table.setDataset data

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            Import.readFile($scope.file, $scope).then (result) ->
                Table.setDataset result
]
