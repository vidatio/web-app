# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    ($scope, $rootScope, $log) ->

        # The three bool values represent the three tabs in the header
        # @property activeViews
        # @type {Array}
        $scope.activeTabs = [false, true, false]

        # Invert the value of the clicked tab to hide or show views in the editor
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 2 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $log.info "EditorCtrl tabClicked called"
            $log.debug
                message: "EditorCtrl tabClicked called"
                tabIndex: tabIndex

            for i of $scope.activeTabs
                $scope.activeTabs[i] = false

            $scope.activeTabs[tabIndex] = true

            views = [true, true]
            if tabIndex == 0
                views = [true, false]
            else if tabIndex == 1
                views = [true, true]
            else
                views = [false, true]

            changeViews views

        # change active views when a tab in the header is clicked
        # @method changeViews
        # @param {Array} tabs Array of three bool values, which represent the three tabs in the editor
        changeViews = (tabs) ->
            console.log tabs
            [$rootScope.showTableView, $rootScope.showVisualizationView] = tabs
            $log.info "EditorCtrl changeViews called"
            $log.debug
                message: "EditorCtrl changeViews called"
                tabs: tabs

            $scope.activeViews = 0
            for tab in tabs
                if tab
                    $scope.activeViews++
]
