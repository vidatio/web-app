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

        translationKeys =
            "scatter": "DIAGRAMS.SCATTER_PLOT"
            "map": "DIAGRAMS.MAP"
            "parallel": "DIAGRAMS.PARALLEL_COORDINATES"
            "bar": "DIAGRAMS.BAR_CHART"
            "timeseries": "DIAGRAMS.TIME_SERIES"

        $scope.recommend = ->
            runRecommender()
            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent
                color: $scope.color

        runRecommender = ->
            $log.info "VisualizationCtrl recommend called"

            trimmedDataset = vidatio.helper.trimDataset Table.dataset
            recommendationResults = vidatio.recommender.run trimmedDataset, Table.getColumnHeaders()

            if recommendationResults.error?
                $log.error "Visualization Ctrl error at recommend diagram"
                $log.debug
                    error: recommendationResults.error
                $scope.diagramType = false
            else
                $log.info "VisualizationCtrl recommender results: #{JSON.stringify(recommendationResults)}"
                $scope.diagramType = recommendationResults.type
                $scope.xAxisCurrent = String(recommendationResults.xColumn)
                $scope.yAxisCurrent = String(recommendationResults.yColumn)

                $translate(translationKeys[$scope.diagramType]).then (translation) ->
                    $scope.selectedDiagramName = translation

                Table.setDiagramColumns recommendationResults.xColumn, recommendationResults.yColumn

        # After having recommend diagram options, we watch the dataset of the table
        # because the watcher fires at initialization the diagram gets immediately drawn
        $scope.$watch (->
            Table.dataset
        ), ( ->
            $log.info "VisualizationCtrl dataset watcher triggered"

            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent
                color: $scope.color
        ), true

        $scope.meta = Data.meta
        $scope.diagramType = false
        $scope.colHeadersSelection = Table.colHeadersSelection
        $scope.color = "#11DDC6"

        switch Data.meta.fileType
            when "shp"
                $scope.diagramType = "map"
                Map.setScope $scope
            else
                runRecommender()

        $timeout ->
            Progress.setMessage ""

        $scope.updateColor = ->
            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent
                color: $scope.color

        # create a new diagram based on the recommended diagram
        # @method createDiagram
        # @param {String} type
        createDiagram = (options) ->
            $log.info "VisualizationCtrl createDiagram function called"

            trimmedDataset = vidatio.helper.trimDataset Table.dataset
            headers = Table.getColumnHeaders()
            options["headers"] =
                "x": headers[options.xColumn]
                "y": headers[options.yColumn]
            subset = vidatio.helper.getSubset trimmedDataset
            transposedDataset = vidatio.helper.transposeDataset subset
            schema = vidatio.recommender.getSchema transposedDataset

            if vidatio.helper.isDiagramPossible schema[options.xColumn], schema[options.yColumn], options.type
                chartData = trimmedDataset
            else
                $translate('TOAST_MESSAGES.NO_DIAGRAM_POSSIBLE').then (translation) ->
                    ngToast.create
                        className: "danger"
                        content: translation
                chartData = []

            switch options.type
                when "scatter"
                    chart = new vidatio.ScatterPlot chartData, options
                when "map"
                    # Use the whole dataset because we want the other attributes inside the popups
                    geoJSON = Converter.convertArrays2GeoJSON chartData, Table.getColumnHeaders(), {
                        x: options.xColumn,
                        y: options.yColumn
                    }
                    Map.setGeoJSON geoJSON
                    Map.setScope $scope
                when "parallel"
                    chart = new vidatio.ParallelCoordinates chartData, options
                when "bar"
                    chart = new vidatio.BarChart chartData, options
                when "timeseries"
                    chart = new vidatio.TimeseriesChart chartData, options
                else
                    $log.error "VisualizationCtrl options.type not set"

        # @method changeAxisColumnSelection
        # @param {Number} axis
        # @param {Number} id
        $scope.setAxisColumnSelection = (axis, id) ->
            $log.info "VisualizationCtrl changeAxisColumnSelection called"
            $log.debug
                axis: axis
                id: id

            if axis is "y" and isInputValid $scope.xAxisCurrent, id, $scope.diagramType
                $scope.yAxisCurrent = id
            else if axis is "x" and isInputValid id, $scope.yAxisCurrent, $scope.diagramType
                $scope.xAxisCurrent = id
            else
                $translate(translationKeys[$scope.diagramType]).then (diagramName) ->
                    return $translate 'TOAST_MESSAGES.COLUMN_NOT_POSSIBLE',
                        column: Table.getColumnHeaders()[id]
                        diagramType: diagramName
                .then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

                return

            Table.setDiagramColumns $scope.xAxisCurrent, $scope.yAxisCurrent

            createDiagram
                type: $scope.diagramType
                xColumn: $scope.xAxisCurrent
                yColumn: $scope.yAxisCurrent
                color: $scope.color

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (type) ->
            $log.info "VisualizationCtrl selectDiagram called"
            $log.debug
                type: type

            $translate(translationKeys[type]).then (translation) ->
                $scope.selectedDiagramName = translation
                $scope.diagramType = type

                createDiagram
                    type: $scope.diagramType
                    xColumn: $scope.xAxisCurrent
                    yColumn: $scope.yAxisCurrent
                    color: $scope.color

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

        # @method isInputValid
        # @params {Number} x
        # @params {Number} y
        # @params {String} diagrmType
        # @return {Function}
        isInputValid = (x, y, diagramType) ->
            $log.info "VisualizationCtrl isInputValid called"
            $log.debug
                x: x
                y: y
                diagramType: diagramType

            transposedDataset = vidatio.helper.transposeDataset Table.dataset
            subset = vidatio.helper.getSubset transposedDataset

            xSubsetFiltered = subset[x].filter( (value) ->
                return value if value?
            )
            ySubsetFiltered = subset[y].filter( (value) ->
                return value if value?
            )

            xColumnType = vidatio.recommender.getColumnType xSubsetFiltered
            yColumnType = vidatio.recommender.getColumnType ySubsetFiltered

            return vidatio.helper.isDiagramPossible xColumnType, yColumnType, diagramType
    ]
