"use strict"

app = angular.module "app.services"

app.service 'VisualizationService', [
    "TableService"
    "ConverterService"
    "MapService"
    "$log"
    "$translate"
    (Table, Converter, Map, $log, $translate) ->
        class Visualization

            # @method constructor
            # @public
            constructor: ->
                @diagramType = false
                @xAxisCurrent = 0
                @yAxisCurrent = 1
                @color = "#11DDC6"
                @selectDiagramName = null

                @translationKeys =
                    "scatter": "DIAGRAMS.SCATTER_PLOT"
                    "map": "DIAGRAMS.MAP"
                    "parallel": "DIAGRAMS.PARALLEL_COORDINATES"
                    "bar": "DIAGRAMS.BAR_CHART"
                    "timeseries": "DIAGRAMS.TIME_SERIES"

            # @method useRecommendedOptions
            # @public
            recommendDiagram: ->
                $log.info "VisualizationService recommend called"

                trimmedDataset = vidatio.helper.trimDataset Table.dataset
                recommendationResults = vidatio.recommender.run trimmedDataset, Table.getColumnHeaders()

                if recommendationResults.error?
                    $log.error "Visualization Ctrl error at recommend diagram"
                    $log.debug
                        error: recommendationResults.error
                    @diagramType = false
                else
                    $log.info "VisualizationCtrl recommender results: #{JSON.stringify(recommendationResults)}"
                    @diagramType = recommendationResults.type
                    @xAxisCurrent = String(recommendationResults.xColumn)
                    @yAxisCurrent = String(recommendationResults.yColumn)

                    $translate(@translationKeys[@diagramType]).then (translation) =>
                        @selectedDiagramName = translation

                    Table.setDiagramColumns recommendationResults.xColumn, recommendationResults.yColumn

            # @method isInputValid
            # @public
            # @params {Number} x
            # @params {Number} y
            # @params {String} diagrmType
            # @return {Function}
            isInputValid: (x, y, diagramType) ->
                $log.info "VisualizationService isInputValid called"
                $log.debug
                    x: x
                    y: y
                    diagramType: diagramType

                transposedDataset = vidatio.helper.transposeDataset Table.dataset
                subset = vidatio.helper.getSubset transposedDataset

                console.log Table.dataset, transposedDataset, subset

                xSubsetFiltered = subset[x].filter((value) ->
                    return value if value?
                )
                ySubsetFiltered = subset[y].filter((value) ->
                    return value if value?
                )

                xColumnType = vidatio.recommender.getColumnType xSubsetFiltered
                yColumnType = vidatio.recommender.getColumnType ySubsetFiltered

                return vidatio.helper.isDiagramPossible xColumnType, yColumnType, diagramType

            # create a new diagram based on the recommended diagram
            # @method createDiagram
            # @public
            # @param {String} type
            createDiagram: (options) ->
                $log.info "VisualizationService createDiagram function called"

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
                        Map.setInstance()
                        Map.setGeoJSON geoJSON
                    when "parallel"
                        chart = new vidatio.ParallelCoordinates chartData, options
                    when "bar"
                        chart = new vidatio.BarChart chartData, options
                    when "timeseries"
                        chart = new vidatio.TimeseriesChart chartData, options
                    else
                        $log.error "VisualizationCtrl options.type not set"

        new Visualization
]
