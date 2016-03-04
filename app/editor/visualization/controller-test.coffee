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
                setScope: ->
                setGeoJSON: ->

            Data =
                meta:
                    fileType: "shp"

            Progress =
                setDataset: ->

            Converter =
                convertArrays2GeoJSON: ->
                    {}

            @VisualizationCtrl = $controller "VisualizationCtrl",
                $scope: @scope, TableService: Table, MapService: Map, DataService: Data,
                ProgressService: Progress, ConverterService: Converter

            spyOn(vidatio.helper, 'trimDataset').and.callThrough()

    afterEach ->
        vidatio.helper.trimDataset.calls.reset()

    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            @scope.updateColor()
            expect(vidatio.helper.trimDataset).toHaveBeenCalled()

            @scope.setAxisColumnSelection("x", 0)
            expect(vidatio.helper.trimDataset).toHaveBeenCalled()

            @scope.selectDiagram()
            expect(vidatio.helper.trimDataset).toHaveBeenCalled()
