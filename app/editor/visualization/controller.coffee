# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    "$timeout"
    "ShareService"
    "DataService"
    "ProgressService"
    "ngToast"
    "$log"
    "ConverterService"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter) ->
        $scope.supportedDiagrams = [
            {
                name: "Scatterplot"
                type: "scatter"
            }
            {
                name: "Map"
                type: "map"
            }
            {
                name: "Parallel Coordinates"
                type: "parallel"
            }
            {
                name: "Barchart"
                type: "bar"
            }
            {
                name: "Timeseries chart"
                type: "timeseries"
            }
        ]

        $scope.selectedDiagramName = ""
        $scope.selectedDiagramType = ""
        $scope.colHeadersSelection = Table.colHeadersSelection

        createDiagram = (type) ->
            switch type
                when "scatter"
                    # Currently default labels for the points are used
                    $scope.chartData[0].unshift "A_x"
                    $scope.chartData[1].unshift "A"
                    visualization = new vidatio.ScatterPlot $scope.chartData
                when "map"
                    # TODO map dataset and merge parser & recommender
                    Map.setScope $scope
                    # Use the hole dataset because we want the other attributes inside the popups
                    geoJSON = Converter.convertArrays2GeoJSON trimmedDataset
                    Map.setGeoJSON geoJSON
                when "parallel"
                    # Parallel coordinate chart need the columns as rows so we transpose
                    $scope.chartData = vidatio.helper.transposeDataset $scope.chartData
                    visualization = new vidatio.ParallelCoordinates $scope.chartData
                when "bar"
                    # Bar chart need the columns as rows so we transpose
                    $scope.chartData = vidatio.helper.transposeDataset $scope.chartData
                    visualization = new vidatio.BarChart $scope.chartData
                when "timeseries"
                    # Currently default labels for the bars are used
                    $scope.chartData[0].unshift "x"
                    $scope.chartData[1].unshift "A"
                    visualization = new vidatio.TimeseriesChart $scope.chartData
                else
                    # TODO: show a default image here
                    $log.error "EdtiorCtrl recommend diagram failed, dataset isn't usable with vidatio"

        $scope.setXAxisColumnSelection = (id) ->
            $log.info "Visualization controller setXAxisColumnSelection called"
            $scope.xAxisCurrent = id
            $scope.changeAxisColumnSelection()

        $scope.setYAxisColumnSelection = (id) ->
            $log.info "Visualization controller setYAxisColumnSelection called"
            $scope.yAxisCurrent = id
            $scope.changeAxisColumnSelection()

        $scope.changeAxisColumnSelection = ->
            $log.info "Visualization controller changeAxisColumnSelection called"

            if $scope.diagramType? and $scope.diagramType isnt "map"
                chartData = [trimmedDataset.map((value, index) -> value[$scope.xAxisCurrent]),
                    trimmedDataset.map((value, index) -> value[$scope.yAxisCurrent])]
                visualization.updateDataset(chartData)

        visualization = null

        dataset = Table.getDataset()
        trimmedDataset = vidatio.helper.trimDataset(dataset)
        cuttedDataset = vidatio.helper.cutDataset(trimmedDataset)

        switch Data.meta.fileType
            when "shp"
                $scope.diagramType = "map"
                Map.setScope $scope
            else
                { recommendedDiagram, xColumn, yColumn } = vidatio.recommender.run cuttedDataset, dataset
                $log.info "Recommender chose type: #{recommendedDiagram} with column #{xColumn} and #{yColumn}"
                $scope.diagramType = recommendedDiagram

                $scope.xAxisCurrent = String(xColumn)
                $scope.yAxisCurrent = String(yColumn)

                $scope.chartData = [trimmedDataset.map((value, index) -> value[xColumn]),
                    trimmedDataset.map((value, index) -> value[yColumn])]

                createDiagram(recommendedDiagram)

        $timeout ->
            Progress.setMessage ""

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "ShareCtrl shareVisualization called"
            $log.debug
                message: "ShareCtrl shareVisualization called"
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "ShareCtrl shareVisualization promise success called"
                $log.debug
                    message: "Share mapToImg success callback"
                    obj: obj

                Progress.setMessage ""

                if Data.meta.fileName == ""
                    fileName = vidatio.helper.dateToString(new Date())
                else
                    fileName = Data.meta.fileName

                Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"
            , (notify) ->
                Progress.setMessage notify

        $scope.selectDiagram = (name, type) ->
            $scope.selectedDiagramName = name
            $scope.selectedDiagramType = type
            console.log("name:", name)
            console.log("TYPE:", type)
]
