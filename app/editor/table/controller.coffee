"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    ($scope, $rootScope, $timeout, Table) ->

        #$scope.test= "hallo lukas";
        $scope.dataset = Table.dataset;
        $scope.views = $rootScope.activeViews;

        # console.log "init"
        # console.log $scope.views
        # console.log $rootScope.activeViews

        # After the dataset has changed the table has to render the updates
        # $scope.$watch (->
        #     Table.dataset
        # ), ( ->
        #     #$scope.render()
        # ), true

        # # After changing the visible views the table has to redraw itself
        # $scope.$watch (->
        #     $rootScope.activeViews
        # ), ( ->
        #     # console.log "watch"
        #     # console.log $rootScope.activeViews
        #     # Render when the page is updated
        #    # $scope.$digest( ->
        #         #$scope.render()
        #    # )
        # ), true
]
