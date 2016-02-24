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
        $scope.activeViews = 2
        $scope.activeTabs = [false, true, false]
        views = [true, true]
        [$rootScope.showTableView, $rootScope.showVisualizationView] = views

        # the displayed views are set according to the clicked tab
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

            if tabIndex == 0
                views = [true, false]
            else if tabIndex == 1
                views = [true, true]
            else
                views = [false, true]

            changeViews views

        # change active views when a tab in the header is clicked
        # them are only two bool values as the second tab uses both views
        # @method changeViews
        # @param {Array} tabs Array of two bool values, which represent the three tabs in the editor
        changeViews = (viewsToDisplay) ->
            [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay
            $log.info "EditorCtrl changeViews called"
            $log.debug
                message: "EditorCtrl changeViews called"
                tabs: viewsToDisplay

            $scope.activeViews = 0
            for tab in viewsToDisplay
                if tab
                    $scope.activeViews++
]
