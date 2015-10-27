"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    "$log"
    ($scope, $rootScope, $timeout, Table, $log) ->
        $scope.dataset = Table.dataset
        $scope.colHeaders = Table.colHeaders
]
