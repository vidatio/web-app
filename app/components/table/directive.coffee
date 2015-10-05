"use strict"
app = angular.module "app.directives"

app.directive 'hot', [
    "$timeout"
    "DataService"
    ($timeout, Data) ->
        restriction: "EA"
        template: '<div id="datatable"></div>'
        replace: true
        scope:
            dataset: '='
            activeViews: '='
            colHeaders: '='
        link: ($scope, $element) ->
            hot = new Handsontable($element[0],
                data: $scope.dataset
                minCols: 26
                minRows: 26
                rowHeaders: true
                colHeaders: $scope.colHeaders
                currentColClassName: 'current-col'
                currentRowClassName: 'current-row'
                beforeChange: (change, source) ->
                    # if !Data.updateTableAndMap(change[0][0], change[0][1], change[0][2], change[0][3])
                    #     # If Data.updateTableAndMap is true, the value should not be changed -> newValue = oldValue
                    #     change[0][3] = change[0][2]
                    return

                afterChange: (change, source) ->
                    console.log change
                    Data.updateTableAndMap(change[0][0], change[0][1], change[0][2], change[0][3])
                    # Needed for updating the map, else the markers are
                    # updating too late from angular refreshing cycle
                    # Data.updateTableAndMap(change[0][0], change[0][1], change[0][2], change[0][3]) if change
                    $scope.$applyAsync()
            )

            # Render of table is even then called, when table
            # view is not active, refactoring possible
            $scope.$watch (->
                $scope.activeViews
            ), ( ->
                # Need to wait for digest cycle
                # apply and digest don't work
                $timeout(->
                    hot.render()
                , 25)
            ), true

            $scope.$watch (->
                $scope.dataset
            ), ( ->
                hot.render()
            ), true

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
