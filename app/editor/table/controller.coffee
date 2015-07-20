"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    ($scope, $rootScope, $timeout, Table) ->

        # After the dataset has changed the table has to render the updates
        $scope.$watch (->
            Table.dataset
        ), ( ->
            $scope.render()
        ), true

        # After changing the visible views the table has to redraw itself
        $scope.$watch (->
            $rootScope.activeViews
        ), ( ->
            # Need a timeout to wait for the rendered scrollbars
            $timeout( ->
                $scope.render()
            ,25)
        ), true
]
