"use strict"

app = angular.module "app.services"

app.service 'VisualizationService', [
    "TableService"
    "ConverterService"
    "MapService"
    "$log"
    "$translate"
    "ngToast"
    (Table, Converter, Map, $log, $translate, ngToast) ->
        class Visualization

            # @method constructor
            # @public
            constructor: ->
                $log.info "VisualizationService constructor called"

                @options =
                    type: false
                    xColumn: 0
                    yColumn: 1
                    color: "#11DDC6"
                    selectedDiagramName: null
                    translationKeys:
                        "scatter": "DIAGRAMS.SCATTER_PLOT"
                        "map": "DIAGRAMS.MAP"
                        "parallel": "DIAGRAMS.PARALLEL_COORDINATES"
                        "bar": "DIAGRAMS.BAR_CHART"
                        "timeseries": "DIAGRAMS.TIME_SERIES"

            resetOptions: ->
                @options.type = false
                @options.xColumn = 0
                @options.yColumn = 1
                @options.color = "#11DDC6"
                @options.selectedDiagramName = null

            # @method useRecommendedOptions
            # @public
            recommendDiagram: ->
                $log.info "VisualizationService recommend called"

                trimmedDataset = vidatio.helper.trimDataset Table.getDataset()
                recommendationResults = vidatio.recommender.run trimmedDataset, Table.getHeader(), Table.useColumnHeadersFromDataset

                if recommendationResults.error?
                    $log.error "Visualization Ctrl error at recommend diagram"
                    $log.debug
                        error: recommendationResults.error
                    @options.type = false
                else
                    $log.info "VisualizationCtrl recommender results: #{JSON.stringify(recommendationResults)}"
                    @options.type = recommendationResults.type
                    @options.xColumn = String(recommendationResults.xColumn)
                    @options.yColumn = String(recommendationResults.yColumn)

                    $translate(@options.translationKeys[@options.type]).then (translation) =>
                        @options.selectedDiagramName = translation

            # create a new diagram based on the recommended diagram
            # @method create
            # @public
            # @param {String} type
            create: (options = @options) ->
                $log.info "VisualizationService create called"
                $log.debug
                    options: options

                chartData = vidatio.helper.trimDataset Table.getDataset()
                headers = Table.getHeader()
                options["headers"] =
                    "x": if headers[options.xColumn]? then headers[options.xColumn] else "x"
                    "y": if headers[options.yColumn]? then headers[options.yColumn] else "y"

                switch options.type
                    when "scatter"
                        new vidatio.ScatterPlot chartData, options
                    when "map"
                        # Use the whole dataset because we want the other attributes inside the popups
                        geoJSON = Converter.convertArrays2GeoJSON chartData, Table.getHeader(), {
                            x: options.xColumn,
                            y: options.yColumn
                        }
                        Map.setInstance()
                        Map.setGeoJSON geoJSON
                    when "parallel"
                        new vidatio.ParallelCoordinates chartData, options
                    when "bar"
                        new vidatio.BarChart chartData, options
                    when "timeseries"
                        new vidatio.TimeseriesChart chartData, options
                    else
                        $log.info "VisualizationCtrl type not set"
                        $log.debug
                            type: options.type

                initInlineEditingLabels()

            initInlineEditingLabels = ->
                $log.info "VisualizationService initInlineEditingLabels called"

                $ "#chart"
                .on "click", "#d3plus_graph_xlabel, #d3plus_graph_ylabel", (event) ->
                    $element = $(@)
                    minWidth = 200

                    inputSize =
                        width: $element.width() + 20
                        height: ($element.height() || 14) + 16

                    if inputSize.width < minWidth
                        inputSize.width = minWidth

                    defaultCss =
                        "min-width": "#{minWidth}px"
                        "width": "#{inputSize.width}px"
                        "height": "#{inputSize.height}px"

                    if $element.attr("id") is "d3plus_graph_ylabel"
                        inputPosition =
                            "left": "-#{(inputSize.width / 2) - 6}px"
                            "top": "50%"
                            "margin-top": "-#{inputSize.height}px"
                            "transform": "rotate(-90deg)"
                        axis = "Y"
                    else
                        offsetTop = $("svg#d3plus").height() - inputSize.height

                        inputPosition =
                            "left": "50%"
                            "top": "#{offsetTop}px"
                            "margin-left": "-#{inputSize.width / 2}px"
                        axis = "X"

                    $ "<input id='#{$element.attr("id")}_inline_input' type='text' value='#{$element.text()}' />"
                    .css angular.extend defaultCss, inputPosition
                    .appendTo "#chart"
                    .focus()
                    .select()
                    .blur (event) ->
                        $element.text $(@).val() || axis
                        $(@).remove()
                    .keyup (event) ->
                        if event.keyCode is 13 or event.keyCode is 27
                            $element.text $(@).val() || axis
                            $(@).remove()

                return true

        new Visualization
]
