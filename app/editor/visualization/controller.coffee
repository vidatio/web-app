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
    "$translate"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter, $translate) ->
        visualization = undefined
        chartData = undefined
        $scope.colHeadersSelection = Table.colHeadersSelection

        dataset = Table.getDataset()
        trimmedDataset = vidatio.helper.trimDataset(dataset)
        subset = vidatio.helper.getSubset(trimmedDataset)

        $translate([
            "DIAGRAMS.DIAGRAM_TYPE"
            "DIAGRAMS.SCATTER_PLOT"
            "DIAGRAMS.MAP"
            "DIAGRAMS.PARALLEL_COORDINATES"
            "DIAGRAMS.BAR_CHART"
            "DIAGRAMS.TIME_SERIES"
        ]).then (translations) ->
            $scope.selectedDiagramName = translations["DIAGRAMS.DIAGRAM_TYPE"]
            $scope.supportedDiagrams = [
                {
                    name: translations["DIAGRAMS.SCATTER_PLOT"]
                    type: "scatter"
                    imagePath: "/images/diagram-icons/scatter-plot.svg"
                }
                {
                    name: translations["DIAGRAMS.MAP"]
                    type: "map"
                    imagePath: "/images/diagram-icons/map.svg"
                }
                {
                    name: translations["DIAGRAMS.PARALLEL_COORDINATES"]
                    type: "parallel"
                }
                {
                    name: translations["DIAGRAMS.BAR_CHART"]
                    type: "bar"
                    imagePath: "/images/diagram-icons/bar-chart.svg"
                }
                {
                    name: translations["DIAGRAMS.TIME_SERIES"]
                    type: "timeseries"
                    imagePath: "/images/diagram-icons/line-chart.svg"
                }
            ]
            return $scope.supportedDiagrams
        .then (supportedDiagrams) ->
            for diagram in supportedDiagrams
                if diagram.type is $scope.diagramType
                    $scope.selectedDiagramName = diagram.name

        # create a new diagram based on the recommended diagram
        # @method createDiagram
        # @param {String} type
        createDiagram = (options) ->
            $log.info "Visualization controller createDiagram function called"

            headers = Table.getColumnHeaders()

            options["headers"] = {}
            options.headers["x"] = headers[options.xColumn]
            options.headers["y"] = headers[options.yColumn]

            switch options.type
                when "scatter"
                    visualization = new vidatio.ScatterPlot trimmedDataset, options
                when "map"
                    # Use the whole dataset because we want the other attributes inside the popups
                    geoJSON = Converter.convertArrays2GeoJSON trimmedDataset, Table.getColumnHeaders(), {
                        x: options.xColumn,
                        y: options.yColumn
                    }
                    Map.setGeoJSON geoJSON
                    Map.setScope $scope
                when "parallel"
                    visualization = new vidatio.ParallelCoordinates trimmedDataset, options
                when "bar"
                    visualization = new vidatio.BarChart trimmedDataset, options
                when "timeseries"
                    visualization = new vidatio.TimeseriesChart trimmedDataset, options
                else
                    # TODO: show a default image here
                    $log.error "EdtiorCtrl recommend diagram failed, dataset isn't usable with vidatio"

        $scope.meta = Data.meta

        $scope.diagramType = false

        # @method setXAxisColumnSelection
        # @param {Number} id
        $scope.setXAxisColumnSelection = (id) ->
            $log.info "Visualization controller setXAxisColumnSelection called"
            $scope.xAxisCurrent = id
            $scope.changeAxisColumnSelection()

        # @method setYAxisColumnSelection
        # @param {Number} id
        $scope.setYAxisColumnSelection = (id) ->
            $log.info "Visualization controller setYAxisColumnSelection called"
            $scope.yAxisCurrent = id
            $scope.changeAxisColumnSelection()

        # @method changeAxisColumnSelection
        $scope.changeAxisColumnSelection = ->
            $log.info "Visualization controller changeAxisColumnSelection called"

            if $scope.diagramType? and $scope.diagramType isnt "map"
                # trimmedDataset: 2D dataset
                # value: row of the 2D dataset
                # value[$scope.xAxisCurrent]: cell of row
                # map: collects the cells of the selected columns
                chartData = [trimmedDataset.map((value, index) -> value[$scope.xAxisCurrent]),
                    trimmedDataset.map((value, index) -> value[$scope.yAxisCurrent])]
                visualization.updateDataset(chartData)

        switch Data.meta.fileType
            when "shp"
                $scope.diagramType = "map"
                Map.setScope $scope
            else
                recommendationResults = vidatio.recommender.run trimmedDataset, Table.getColumnHeaders()

                if recommendationResults.error?
                    $log.error
                        message: recommendationResults.error
                    if recommendationResults.error is "not enough dimensions"
                            $translate('TOAST_MESSAGES.NOT_ENOUGH_DIMENSIONS').then (translation) ->
                                ngToast.create
                                    className: "danger"
                                    content: translation
                else
                    $log.info "Recommender Results: #{JSON.stringify(recommendationResults)}"

                    $scope.diagramType = recommendationResults.type
                    $scope.xAxisCurrent = String(recommendationResults.xColumn)
                    $scope.yAxisCurrent = String(recommendationResults.yColumn)
                    createDiagram(recommendationResults)

        $timeout ->
            Progress.setMessage ""

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (name, type) ->
            $log.info "Visualization controller selectDiagram called"
            $log.debug
                name: name
                type: type

            $scope.selectedDiagramName = name
            $scope.diagramType = type

            createDiagram
                type: type
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent

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
]
