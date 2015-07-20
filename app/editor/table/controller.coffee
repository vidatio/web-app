"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    ($scope, $rootScope, $timeout, Table) ->

        #$scope.test= "hallo lukas";
        $scope.dataset = Table.dataset
        $scope.views = $rootScope.activeViews

        $scope.$watch (->
            $rootScope.activeViews
        ), ( ->
            console.log "watch ctrl views"
            $scope.views = $rootScope.activeViews
        ), true

        $scope.$watch (->
            Table.dataset
        ), ( ->
            console.log "watch ctrl data"
            $scope.dataset = Table.dataset
        ), true

]
