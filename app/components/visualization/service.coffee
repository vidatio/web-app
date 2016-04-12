"use strict"

app = angular.module "app.services"

app.service 'VisualizationService', [
    "TableService"
    "ConverterService"
    "MapService"
    "$log"
    "$translate"
    "$timeout"
    "ProgressService"
    "ngToast"
    "$rootScope"
    (Table, Converter, Map, $log, $translate, $timeout, Progress, ngToast, $rootScope) ->
        class Visualization

            # @method constructor
            # @public
            constructor: ->
                @options =
                    fileType: "csv"
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
                    $translate(@options.translationKeys[options.type]).then (translation) =>
                        @options["selectedDiagramName"] = translation
                else
                    @options["type"] = null
                    @options["selectedDiagramName"] = null

                @options["xColumn"] = if options.xColumn? then parseInt(options.xColumn, 10) else null
                @options["yColumn"] = if options.yColumn? then parseInt(options.yColumn, 10) else null
                @options["color"] = if options.color? then options.color else "#11DDC6"
                @options["fileType"] = if options.fileType? then options.fileType else null

            # @method useRecommendedOptions
            # @public
            useRecommendedOptions: ->
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

                # set width and height of the visualization for dynamic resizing
                chartSelector = "#chart"
                $chart = $(chartSelector)
                width = $chart.parent().width()
                height = $chart.parent().height()

                switch options.type
                    when "scatter"
                        new vidatio.ScatterPlot chartData, options, width, height, chartSelector
                    when "map"
                        # only create the geoJSON from the table, if we don't use shp
                        # because otherwise we geoJSON is directly updated and so no conversion is needed
                        # and also because we don't have the xColumn of yColumn saved
                        if options.fileType isnt "shp"
                            # Use the whole dataset because we want the other attributes inside the popups
                            geoJSON = Converter.convertArrays2GeoJSON chartData, Table.getHeader(), {
                                x: options.xColumn,
                                y: options.yColumn
                            }
                            Map.setGeoJSON geoJSON

                        Map.setInstance()
                    when "parallel"
                        new vidatio.ParallelCoordinates chartData, options, width, height, chartSelector
                    when "bar"
                        new vidatio.BarChart chartData, options, width, height, chartSelector
                    when "timeseries"
                        new vidatio.TimeseriesChart chartData, options, width, height, chartSelector
                    else
                        $log.warn "VisualizationCtrl type not set"
                        $log.debug
                            type: options.type

                if (options.type isnt "map" or options.type isnt "parallel") and $rootScope.title is "editor"
                    initInlineEditingLabels.call @

            initInlineEditingLabels = ->
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

            downloadAsImage: (fileName, type) ->
                $translate("OVERLAY_MESSAGES.VISUALIZATION_PREPARED").then (translation) ->
                    Progress.setMessage translation

                if @options.type is "map"
                    $targetElem = $("#map")
                else if @options.type is "parallel"
                    $targetElem = $("#chart svg")
                else
                    $targetElem = $("#d3plus")

                vidatio.visualization.visualizationToBase64String($targetElem)
                .then (obj) ->
                    Progress.setMessage ""

                    vidatio.visualization.download "#{fileName}.#{type}", obj[type]

                .catch (error) ->
                    $translate(error.i18n).then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

        new Visualization
]
