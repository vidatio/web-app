"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    ($scope, $rootScope, $timeout, Table) ->

        $scope.dataset = Table.getDataset()

        $scope.$watch (->
            Table.dataset
        ), ( ->
            $scope.dataset = Table.getDataset()
        ), true

]
