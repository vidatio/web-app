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

        $scope.editor = Data

        # check if userAgent is Firefox -> necessary for the width calculation of the input field
        isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1

        # set the initial values and display both Table- and Display-View on start
        $scope.activeViews = 2
        $scope.activeTabs = [false, true, false]
        viewsToDisplay = [true, true]
        [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

        # set initial values for displayed title and input-field length
        # standardTitle is needed, if user sets no title
        $translate("NEW_VIDATIO").then (translation) ->
            $scope.standardTitle = translation
            if $scope.editor.name is ""
                $scope.editor.name = $scope.standardTitle

        $timeout -> $("#vidatio-title").css "width", setTitleInputWidth()

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

        # watcher for text input in the title input field
        $("#vidatio-title").on 'input', ->
            $("#vidatio-title").css "width", setTitleInputWidth()

        # @method saveVidatioTitle
        # @description set the users' input (if existing) as Vidatio-title; set a standard-title or the original filename otherwise
        $scope.saveVidatioTitle = ->
            $log.info "EditorCtrl saveVidatioTitle called"

            if $scope.editor.name is ""
                $scope.editor.name = $scope.standardTitle

            $timeout -> $("#vidatio-title").css "width", setTitleInputWidth()

            $log.debug
                title: $scope.editor.name

            return true # necessary to solve the Angular error: "Referencing DOM nodes in Angular expressions is disallowed!"

        # @method setTitleInputWidth
        # @description calculate and return the necessary width for the input field
        setTitleInputWidth = ->
            inputWidth = $("#vidatio-title").textWidth()

            # firefox calculates the letter-widths in a different manner than other browsers
            # -> fine adjustments needed according to calculated textWidth
            if isFirefox
                if inputWidth < 150
                    inputWidth = inputWidth * 1.5 + "px"
                else
                    inputWidth = inputWidth * 1.4 + "px"
            else
                inputWidth = inputWidth + 10 + "px"

            return inputWidth
]
