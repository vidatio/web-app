# Editor Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "EditorCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    ($scope, $rootScope, $log) ->
        # set the initial values and display both Table- and Display-View on start
        $scope.activeViews = 2
        $scope.activeTabs = [false, true, false]
        viewsToDisplay = [true, true]
        [$rootScope.showTableView, $rootScope.showVisualizationView] = viewsToDisplay

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

        # the following lines are a solution from stack-overflow
        # the input-field width automatically resizes according to a users' input
        $.fn.textWidth = (text, font) ->
            if !$.fn.textWidth.fakeEl
                $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body)
            $.fn.textWidth.fakeEl.text(text or @val() or @text()).css 'font', font or @css('font')
            $.fn.textWidth.fakeEl.width()

        # eventlistener to call the resize function of the input-element above
        $('#vidatio-title').on('input', ->
            paddingBetweenLetters = 10 # works as a minimum width
            valWidth = $(this).textWidth() + paddingBetweenLetters + 'px'
            $('#vidatio-title').css 'width', valWidth
            $('.underline-title').css 'width', valWidth
            return
        ).trigger 'input'

        # remove edit-icon on first click at the input-field
        $('#vidatio-title').click ->
            $('.icon-vidatio-title').css 'display', 'none'
            return
]
