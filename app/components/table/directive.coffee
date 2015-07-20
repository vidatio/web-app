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
                offset = Handsontable.Dom.offset $element[0]

                wrapperWidth = Handsontable.Dom.innerWidth $element.parent()[0]
                wrapperHeight = Handsontable.Dom.innerHeight $element.parent()[0]
                availableWidth = wrapperWidth - offset.left - offset.right
                availableHeight = wrapperHeight - offset.top - offset.bottom

                $element.parent()[0].style.width = availableWidth + 'px'
                $element.parent()[0].style.height = availableHeight + 'px'
                hot.render()
]
