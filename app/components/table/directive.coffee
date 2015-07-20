"use strict"
app = angular.module "app.directives"

app.directive 'hot', [
    "TableService"
    (Table) ->
        restriction: "EA"
        link: ($scope, $element, attrs) ->

            console.log "start link"
            console.log attrs
            console.log attrs.dataSet
            console.log attrs.activeViews

            hot = new Handsontable($element[0],
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
]
