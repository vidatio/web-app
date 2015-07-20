"use strict"
app = angular.module "app.directives"

app.directive 'data-table',
    "Table"
    (Table) ->
    restriction: "EA"
    link: ($scope, $element) ->

        hot = new Handsontable($element,
            data: Table.dataset
            minCols: 100
            minRows: 100
            rowHeaders: true
            colHeaders: true
            currentColClassName: 'current-col'
            currentRowClassName: 'current-row')

        $scope.render = ->
            hot.render()

        # Needed for correct displayed table
        Handsontable.Dom.addEvent window, 'resize', ->
            offset = Handsontable.Dom.offset $element

            wrapperWidth = Handsontable.Dom.innerWidth $element.parent
            wrapperHeight = Handsontable.Dom.innerHeight $element.parent
            availableWidth = wrapperWidth - offset.left - offset.right
            availableHeight = wrapperHeight - offset.top - offset.bottom

            tableTag.style.width = availableWidth + 'px'
            tableTag.style.height = availableHeight + 'px'
            hot.render()
