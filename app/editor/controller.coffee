# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    "$timeout"
    "DataService"
    "ngToast"
    "$translate"
    "VisualizationService"
    "MapService"
    "$window"
    "$stateParams"
    "$state"
    "TableService"
    "ImportService"
    ($scope, $rootScope, $log, $timeout, Data, ngToast, $translate, Visualization, Map, $window, $stateParams, $state, Table, Import) ->
        if $stateParams.id and not Table.dataset[0].length
            Data.requestVidatioViaID($stateParams.id)

        $scope.editor = Data
        $scope.setBoundsToGeoJSON = ->
            Map.setBoundsToGeoJSON()

        # set the initial values and display both Table- and Display-View on start
        $scope.activeViews = 2
        $scope.activeTabs = [false, true, false]
        viewsToDisplay = [true, true]
        [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

        # call changeViews function and set stateParams to the new tab index
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 2 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            for i of $scope.activeTabs
                $scope.activeTabs[i] = false

            $scope.activeTabs[tabIndex] = true

            # change active views accordingly to the clicked tab
            # them are only two bool values as the second tab uses both views
            if tabIndex == 0
                viewsToDisplay = [true, false]
            else if tabIndex == 1
                viewsToDisplay = [true, true]
            else
                viewsToDisplay = [false, true]

            [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

            # call Visualization.create() each time the tabs 1 and 2 are clicked as the diagram needs to be resized
            unless tabIndex is 0
                $timeout ->
                    Visualization.create()
                , 100

            # count activeViews to set bootstrap classes accordingly for editor-width
            $scope.activeViews = 0
            for tab in viewsToDisplay
                if tab
                    $scope.activeViews++

            unless tabIndex is 2
                $timeout ->
                    window.angular.element($window).triggerHandler("resize")
                , 100

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = (file) ->
            Import.getFile file
]
