"use strict"
app = angular.module "app.directives"

app.directive "hot", [
    "$timeout"
    "DataService"
    "MapService"
    "TableService"
    "ConverterService"
    "$window"
    "VisualizationService"
    ($timeout, Data, Map, Table, Converter, $window, Visualization) ->
        restriction: "EA"
        template: "<div id='datatable'></div>"
        replace: true
        scope:
            dataset: "="
            activeViews: "="
            useColumnHeadersFromDataset: "="
        link: ($scope, $element) ->
            minWidth = 26
            minHeight = 26

            if Table.useColumnHeadersFromDataset
                header = Table.getHeader()
                for i in [header.length...minWidth]
                    header.push null
            else
                header = true

            columns = minWidth - Table.getDataset()[0].length
            minSpareCols = if columns > 0 then columns else 0

            rows = minHeight - Table.getDataset().length
            minSpareRows = if rows > 0 then rows else 0

            hot = null
            do ->
                hot = new Handsontable($element[0],
                    data: Table.dataset
                    minCols: minWidth
                    minRows: minHeight
                    minSpareCols: minSpareCols
                    minSpareRows: minSpareRows
                    rowHeaders: true
                    colHeaders: header
                    currentColClassName: "current-col"
                    currentRowClassName: "current-row"
                    manualColumnResize: true
                    beforeChange: (change, source) ->
                        # Prevents user to delete whole row or column in shp-files
                        if change.length > 1 and Data.metaData.fileType is "shp"
                            change.forEach (element, index) ->
                                element[3] = element[2]

                        if Data.metaData.fileType is "shp" and !Data.validateInput(change[0][0], change[0][1], change[0][2], change[0][3])
                            change[0][3] = change[0][2]

                    afterChange: (change, source) ->
                        if Data.metaData.fileType is "shp" and change and change[0][3] != change[0][2]
                            Data.updateMap(change[0][0], change[0][1], change[0][2], change[0][3])
                            # Needed for updating the map, else the markers are
                            # updating too late from angular refreshing cycle
                            $scope.$applyAsync()
                        else if change and change[0][3] != change[0][2]
                            $timeout ->
                                Visualization.create()
                )

            Table.setInstance hot

            if not Table.useColumnHeadersFromDataset
                Table.setHeader()

            if Data.metaData.fileType is "shp"
                geoJSON = Map.getGeoJSON()
                columnHeaders = Converter.convertGeoJSON2ColHeaders geoJSON
                Table.setHeader columnHeaders, "shp"
                Table.setColumns()
            else
                # Initialize "X" and "Y" on table header
                xColumn = if Visualization.options?.xColumn? then Number(Visualization.options.xColumn) + 1 else 1
                yColumn = if Visualization.options?.yColumn? then Number(Visualization.options.yColumn) + 1 else 2

                $header = $(".ht_clone_top th")

                $header.each (idx, element) ->
                    if idx is xColumn and idx is yColumn
                        $(element).find("span").addClass "selected-x-y"
                    else if idx is xColumn
                        $(element).find("span").addClass "selected-x"
                    else if idx is yColumn
                        $(element).find("span").addClass "selected-y"

                Table.updateAxisSelection(xColumn, yColumn)

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
            onResizeCallback = ->
                offset = Handsontable.Dom.offset $element[0]

                wrapperWidth = Handsontable.Dom.innerWidth $element.parent()[0]
                wrapperHeight = Handsontable.Dom.innerHeight $element.parent()[0]
                availableWidth = wrapperWidth - offset.left - offset.right
                availableHeight = wrapperHeight - offset.top - offset.bottom

                $element.parent()[0].style.width = availableWidth + "px"
                $element.parent()[0].style.height = availableHeight + "px"
                hot.render()
                return

            # resize event only should be fired if user is currently in editor
            window.angular.element($window).on "resize", onResizeCallback

            # resize watcher has to be removed when editor is leaved
            $scope.$on "$destroy", ->
                window.angular.element($window).off "resize", onResizeCallback
]
