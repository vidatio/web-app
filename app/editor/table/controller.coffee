"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "TableService"
    ($scope, $rootScope, $timeout, Table) ->

        tableTag = document.querySelector("#hot")
        tableWrapperTag = document.querySelector("#table .content")

        hot = new Handsontable(tableTag,
            data: Table.dataset
            minCols: 100
            minRows: 100
            rowHeaders: true
            colHeaders: true
            currentColClassName: 'current-col'
            currentRowClassName: 'current-row')

        # After the dataset has changed the table has to render the updates
        $scope.$watch (->
            Table.dataset
        ), ( ->
            hot.render()
        ), true

        # After changing the visible views the table has to redraw itself
        $scope.$watch (->
            $rootScope.activeViews
        ), ( ->
            # Need a timeout to wait for the rendered scrollbars
            $timeout( ->
                hot.render()
            ,25)
        ), true

        # Needed for correct displayed table
        Handsontable.Dom.addEvent window, 'resize', ->
            offset = Handsontable.Dom.offset(tableTag)

            wrapperWidth = Handsontable.Dom.innerWidth(tableWrapperTag)
            wrapperHeight = Handsontable.Dom.innerHeight(tableWrapperTag)
            availableWidth = wrapperWidth - offset.left - offset.right
            availableHeight = wrapperHeight - offset.top - offset.bottom

            tableTag.style.width = availableWidth + 'px'
            tableTag.style.height = availableHeight + 'px'
            hot.render()
]
