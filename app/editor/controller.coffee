# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    "$rootScope"
    ($scope, $rootScope) ->
        $rootScope.$watch ( (rootScope) ->
            rootScope.activeViews
        ), ((tabs) ->
            changeViews(tabs)
        ), true

        changeViews = (tabs) ->

            [$rootScope.showTableView, $rootScope.showVisualizationView, $rootScope.showShareView] = tabs
            console.log(tabs)
            $scope.activeViews = 0
            for tab in tabs
                if tab
                    $scope.activeViews++

]
