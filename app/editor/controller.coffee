# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    ($scope, $rootScope, $log) ->
    
        # watch if activeViews in change (defined in headerController.coffee)
        # $watch takes two callbacks (watchExpression and Listener);
        # see Angular.js Docs for more info!
        # @method $watch
        # @param {Function} watchExpression
        # @param {Function} Listener
        $rootScope.$watch ( (rootScope) ->
            rootScope.activeViews
        ), ((tabs) ->
            changeViews tabs if tabs
        ), true

        # change active views when a tab in the header is clicked
        # @method changeViews
        # @param {Array} tabs Array of three bool values, which represent the three tabs in the editor
        changeViews = (tabs) ->
            [$rootScope.showTableView, $rootScope.showVisualizationView] = tabs
            $log.info "EditorCtrl changeViews called"
            $log.debug
                message: "EditorCtrl changeViews called"
                tabs: tabs

            # count active editor views to set bootstrap classes for the correct widths
            $scope.activeViews = 0
            for tab in tabs
                if tab
                    $scope.activeViews++

]
