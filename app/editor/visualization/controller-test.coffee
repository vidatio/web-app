"use strict"

describe "Visualization Ctrl", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope) ->
            @scope = $rootScope.$new()
            @scope.diagramType = "scatter"
            @scope.xAxisCurrent = 0
            @scope.yAxisCurrent = 1

            Table =
                dataset: [["0", "1"]]
                getColumnHeaders: ->
                    ["a", "b"]
                setDiagramColumns: (x, y) ->

            Map =
                setInstance: ->
                setGeoJSON: ->

            Data =
                meta:
                    fileType: "shp"

            Progress =
                setDataset: ->

            Converter =
                convertArrays2GeoJSON: ->
                    {}

            @Visualization =
                isInputValid: ->
                    true
                createDiagram: ->
                recommendDiagram: ->
                translationKeys:
                    "scatter": "DIAGRAMS.SCATTER_PLOT"
                    "map": "DIAGRAMS.MAP"
                    "parallel": "DIAGRAMS.PARALLEL_COORDINATES"
                    "bar": "DIAGRAMS.BAR_CHART"
                    "timeseries": "DIAGRAMS.TIME_SERIES"

            @VisualizationCtrl = $controller "VisualizationCtrl",
                $scope: @scope, TableService: Table, MapService: Map, DataService: Data,
                ProgressService: Progress, ConverterService: Converter, VisualizationService: @Visualization

            spyOn(@Visualization, 'createDiagram')

    afterEach ->
        @Visualization.createDiagram.calls.reset()

    describe "on calling scope functions", ->
        it 'should call the trimdataset function for further processing', ->
            @scope.updateColor()
            expect(@Visualization.createDiagram).toHaveBeenCalled()

            @scope.setAxisColumnSelection("x", 0)
            expect(@Visualization.createDiagram).toHaveBeenCalled()

            @scope.selectDiagram()
            expect(@Visualization.createDiagram).toHaveBeenCalled()
