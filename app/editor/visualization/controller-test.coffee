"use strict"

describe "Visualization Ctrl", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope) ->
            @scope = $rootScope.$new()

            Table =
                dataset: [["0", "1"]]
                getHeader: ->
                    ["a", "b"]
                setDiagramColumns: (x, y) ->

            Map =
                setInstance: ->
                setGeoJSON: ->

            Data =
                meta:
                    fileType: "csv"

            Progress =
                setDataset: ->

            Converter =
                convertArrays2GeoJSON: ->
                    {}

            @Visualization =
                options:
                    type: "scatter"
                    xColumn: 0
                    yColumn: 1
                    color: '#000111'
                    translationKeys:
                        "scatter": "DIAGRAMS.SCATTER_PLOT"
                        "map": "DIAGRAMS.MAP"
                        "parallel": "DIAGRAMS.PARALLEL_COORDINATES"
                        "bar": "DIAGRAMS.BAR_CHART"
                        "timeseries": "DIAGRAMS.TIME_SERIES"
                isInputValid: ->
                    true
                create: ->
                recommendDiagram: ->

            VisualizationCtrl = $controller "VisualizationCtrl",
                $scope: @scope, TableService: Table, MapService: Map, DataService: Data,
                ProgressService: Progress, ConverterService: Converter, VisualizationService: @Visualization

            spyOn(@Visualization, 'create')

    afterEach ->
        @Visualization.create.calls.reset()

    describe "on calling scope functions", ->
        it 'should call the createDiagram function for redrawing the visualization', ->
            @scope.setAxisColumnSelection("x", 0)
            expect(@Visualization.create).toHaveBeenCalled()

            # @scope.selectDiagram()
            # expect(@Visualization.create).toHaveBeenCalled()
