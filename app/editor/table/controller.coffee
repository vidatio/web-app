"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    ($scope, Table) ->
        $scope.rows = Table.dataset
        $scope.settings =
            colHeaders: true
            rowHeaders: true
            minCols: 26
            minRows: 26
            currentRowClassName: 'current-row'
            currentColClassName: 'current-col'

        $scope.afterInit = ->
            $scope.tableInstance = this

        tableTag = document.querySelector("#hot")
        tableWrapperTag = document.querySelector("#table .content")

        Handsontable.Dom.addEvent window, 'resize', ->
            offset = Handsontable.Dom.offset(tableTag)

            wrapperWidth = Handsontable.Dom.innerWidth(tableWrapperTag)
            wrapperHeight = Handsontable.Dom.innerHeight(tableWrapperTag)
            availableWidth = wrapperWidth - offset.left - offset.right
            availableHeight = wrapperHeight - offset.top - offset.bottom

            tableTag.style.width = availableWidth + 'px'
            tableTag.style.height = availableHeight + 'px'
            $scope.tableInstance.render()
]
