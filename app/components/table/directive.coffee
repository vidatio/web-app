"use strict"
app = angular.module "app.directives"

app.directive 'hot',  [
    "$timeout"
    ($timeout) ->
        restriction: "EA"
        template: '<div id="datatable"></div>'
        replace: true
        link: ($scope, $element, attrs) ->
            hot = new Handsontable($element[0],
                data: attrs.dataSet
                minCols: 26
                minRows: 26
                rowHeaders: true
                colHeaders: true
                currentColClassName: 'current-col'
                currentRowClassName: 'current-row')

            attrs.$observe 'activeViews', (val) ->
                hot.render()

            attrs.$observe 'dataSet', (val) ->
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
