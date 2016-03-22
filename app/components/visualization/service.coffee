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

            # @method resetOptions
            # @public
            resetOptions: ->
                @options.type = false
                @options.xColumn = 0
                @options.yColumn = 1
                @options.color = "#11DDC6"
                @options.selectedDiagramName = null

            # @method setOptions
            # @public
            # @param {Object} options
            #   @param {String} color
            #   @param {String} selectedDiagramName
            #   @param {String} type
            #   @param {Int} xColumn
            #   @param {Int} yColumn
            setOptions: (options) ->
                # Each value has to be assigned individually, otherwise all already set options get overwritten
                # and because we want to use data binding
                if options.type?
                    @options["type"] = options.type
                    $translate(@options.translationKeys[options.type]).then (translation) ->
                        @options["selectedDiagramName"] = translation
                else
                    @options["type"] = false
                    @options["selectedDiagramName"] = false

                @options["xColumn"] = if options.xColumn? then parseInt(options.xColumn, 10) else null
                @options["yColumn"] = if options.yColumn? then parseInt(options.yColumn, 10) else null
                @options["color"] = if options.color? then options.color else "#11DDC6"

            # @method useRecommendedOptions
            # @public
            useRecommendedOptions: ->
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

                unless options.type is "map" or options.type is "parallel"
                    initInlineEditingLabels.call @

            initInlineEditingLabels = ->
                $log.info "VisualizationService initInlineEditingLabels called"

                _self = @
                minWidth = 200

                getStyle = ($axisLabel) ->
                    inputTagSize =
                        width: $axisLabel.width() + 20
                        height: ($axisLabel.height() || 14) + 16

                    if inputTagSize.width < minWidth
                        inputTagSize.width = minWidth

                    style =
                        "min-width": "#{minWidth}px"
                        "width": "#{inputTagSize.width}px"
                        "height": "#{inputTagSize.height}px"

                    return {
                        style: style,
                        inputTagSize: inputTagSize
                    }

                addInputTag = ($axisLabel, axis, style) ->
                    $ "<input id='#{$axisLabel.attr("id")}_inline_input' type='text' value='#{$axisLabel.text()}' />"
                    .css angular.extend style
                    .appendTo "#chart"
                    .focus()
                    .select()
                    .blur ->
                        label = $(@).val() || axis.toUpperCase()
                        $axisLabel.text label
                        $(@).remove()
                        header = Table.getHeader()
                        header[_self.options["#{axis}Column"]] = label
                        Table.setHeader header
                    .keyup (event) ->
                        if event.keyCode is 13 or event.keyCode is 27
                            $(@).blur()

                $ "#chart"
                .on "click", "#d3plus_graph_xlabel, #d3plus_graph_ylabel", (event) ->
                    $axisLabel = $(@)
                    { inputTagSize, style } = getStyle $axisLabel

                    if @.id is "d3plus_graph_ylabel"
                        axis = "y"
                        angular.extend style,
                            "left": "-#{(inputTagSize.width / 2) - 6}px"
                            "top": "50%"
                            "margin-top": "-#{inputTagSize.height}px"
                            "transform": "rotate(-90deg)"
                    else
                        axis = "x"
                        angular.extend style,
                            "left": "50%"
                            "top": $("svg#d3plus").height() - inputTagSize.height + "px"
                            "margin-left": "-#{inputTagSize.width / 2}px"

                    addInputTag $axisLabel, axis, style

                return true

        new Visualization
]
