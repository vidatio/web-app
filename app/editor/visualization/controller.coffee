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
        $scope.meta = Data.meta
        $scope.diagramType = false
        $scope.colHeadersSelection = Table.colHeadersSelection

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
            $log.info "VisualizationCtrl createDiagram function called"
            trimmedDataset = vidatio.helper.trimDataset Table.dataset

            headers = Table.getColumnHeaders()

            options["headers"] = {}
            options.headers["x"] = headers[options.xColumn]
            options.headers["y"] = headers[options.yColumn]

            switch options.type
                when "scatter"

                    subset = vidatio.helper.getSubset trimmedDataset
                    transposedDataset = vidatio.helper.transposeDataset subset
                    schema = vidatio.recommender.getSchema transposedDataset

                    if(schema[options.xColumn] isnt "numeric" or schema[options.xColumn] isnt "numeric")
                        $translate('TOAST_MESSAGES.NO_DIAGRAM_POSSIBLE').then (translation) ->
                            ngToast.create
                                className: "danger"
                                content: translation
                        new vidatio.ScatterPlot [[]], options
                    else
                        new vidatio.ScatterPlot trimmedDataset, options

                when "map"
                    # Use the whole dataset because we want the other attributes inside the popups
                    geoJSON = Converter.convertArrays2GeoJSON trimmedDataset, Table.getColumnHeaders(), {
                        x: options.xColumn,
                        y: options.yColumn
                    }
                    Map.setGeoJSON geoJSON
                    Map.setScope $scope
                when "parallel"
                    new vidatio.ParallelCoordinates trimmedDataset, options
                when "bar"
                    new vidatio.BarChart trimmedDataset, options
                when "timeseries"
                    new vidatio.TimeseriesChart trimmedDataset, options
                else
                    # TODO: show a default image here
                    $log.error "VisualizationCtrl recommend diagram failed, dataset isn't usable with vidatio"

        # @method changeAxisColumnSelection
        # @param {Number} axis
        # @param {Number} id
        $scope.changeAxisColumnSelection = (axis, id) ->
            $log.info "VisualizationCtrl changeAxisColumnSelection called"
            $log.debug
                axis: axis
                id: id

            if axis is "y"
                $scope.yAxisCurrent = id
            else if axis is "x"
                $scope.xAxisCurrent = id

            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent

        switch Data.meta.fileType
            when "shp"
                $scope.diagramType = "map"
                Map.setScope $scope
            else
                trimmedDataset = vidatio.helper.trimDataset Table.dataset
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

                # After having recommend diagram options, we watch the dataset of the table
                # because the watcher fires at initialization the diagram gets immediately drawn
                $scope.$watch (->
                    Table.dataset
                ), ( ->
                    $log.info "VisualizationCtrl - dataset has changed so we create a new diagram"

                    createDiagram
                        type: $scope.diagramType
                        xColumn: $scope.xAxisCurrent
                        yColumn: $scope.yAxisCurrent
                ), true

        $timeout ->
            Progress.setMessage ""

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (name, type) ->
            $log.info "VisualizationCtrl selectDiagram called"
            $log.debug
                name: name
                type: type

            $scope.selectedDiagramName = name
            $scope.diagramType = type

            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "VisualizationCtrl shareVisualization called"
            $log.debug
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "VisualizationCtrl shareVisualization promise success called"
                $log.debug
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
