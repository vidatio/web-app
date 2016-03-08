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
    ($scope, $rootScope, $log, $timeout, Data, ngToast, $translate) ->
        # set the initial values and display both Table- and Display-View on start
        $scope.activeViews = 2
        $scope.activeTabs = [false, true, false]
        viewsToDisplay = [true, true]
        [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

        $scope.standardTitle = $translate.instant("NEW_VIDATIO") + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")

        $scope.editor = Data.meta

        $scope.editor.fileName = Data.meta.fileName || $scope.standardTitle
        $timeout -> setTitleInputWidth()

        $("#vidatio-title").on 'input', ->
            setTitleInputWidth()

        # @method saveVidatioTitle
        # @description set the users' input (if existing) as vidatio-title; set a standard-title otherwise
        $scope.saveVidatioTitle = ->
            $log.info "HeaderCtrl saveVidatioTitle called"
            $log.debug
                filename: Data.meta.fileName

            if $scope.editor.fileName is ""
                $("#vidatio-title").css "min-width", 240
            else
                $("#vidatio-title").css "min-width", 10

            # necessary to solve the Angular error: "Referencing DOM nodes in Angular expressions is disallowed!"
            return true

        # the displayed views are set accordingly to the clicked tab
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 2 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $log.info "EditorCtrl tabClicked called"

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

            $log.debug
                message: "EditorCtrl tabClicked called"
                tabIndex: tabIndex
                viewsToDisplay: viewsToDisplay

            [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

            # count activeViews to set bootstrap classes accordingly for editor-width
            $scope.activeViews = 0
            for tab in viewsToDisplay
                if tab
                    $scope.activeViews++

        setTitleInputWidth = ->
            valWidth = $("#vidatio-title").textWidth() + 10 + "px" # 10 is the width per letter
            $("#vidatio-title").css "width", valWidth

]
