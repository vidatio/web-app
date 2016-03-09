"use strict"

describe "Service Data", ->

    beforeEach ->
        module "app"

        inject (DataService, ConverterService, TableService, MapService, $rootScope, $q, $injector, VisualizationService) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()

            @Data = DataService
            @Converter = ConverterService
            @Converter.convertGeoJSON2Arrays = ->
            @Visualization = VisualizationService

            @Map = MapService
            @Map.init @scope

            @Table = TableService
            @Table.getInstance = ->
            @Table.instanceTable =
                getColHeader: ->
                    return [0,1,2,3,4,5,5,6,7]
                updateSettings: ->
                render: ->

            spyOn(@Converter, "convertArrays2GeoJSON")
            spyOn(@Map, "setGeoJSON")
            spyOn(@Map, "updateGeoJSONWithSHP")
            spyOn(@Table, "setDataset")
            spyOn(@Table, "setHeader")

    it "should be defined and included", ->
        expect(@Data).toBeDefined()
        expect(@injector.has("DataService"))

    it "should have a meta object", ->
        expect(@Data.meta).toBeDefined()

    describe "should update Table and Map", ->
        it "with file type csv", ->
            @Data.meta.fileType = "csv"
            @Data.updateMap 0, 0, "oldData", "newData"

            expect(@Converter.convertArrays2GeoJSON).not.toHaveBeenCalled()
            expect(@Map.setGeoJSON).not.toHaveBeenCalled()

        it "with file type shp", ->
            @Data.meta.fileType = "shp"

            @Data.updateMap(0, 0, "oldData", "newData")
            expect(@Map.updateGeoJSONWithSHP).toHaveBeenCalled()

    describe "should create new Vidatio", ->
        data =
                data:
                    [
                        [1, 2, 3],
                        ["one", "two", "three"]
                    ]
                options:
                    diagramType: "bar"
                    xAxisCurrent: 2
                    yAxisCurrent: 3
                    color: "#FF00FF"
                    selectedDiagramName: "Balkendiagramm"
                    useColumnHeadersFromDataset: true

        it "from shp data", ->
            @Data.meta.fileType = "shp"

            @Data.createVidatio data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Map.setGeoJSON).toHaveBeenCalled()
            expect(@Table.useColumnHeadersFromDataset).toEqual(true)


        it "and set visualizaiotn options", ->
            options =
                diagramType: "bar"
                xAxisCurrent: 2
                yAxisCurrent: 3
                color: "#FF00FF"
                selectedDiagramName: "Balkendiagramm"
            @Data.meta.fileType = "csv"

            @Data.createVidatio data
            expect(@Visualization.options).toEqual(jasmine.objectContaining(options))

        it "from csv data with user header", ->
            @Data.meta.fileType = "csv"

            @Data.createVidatio data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setHeader).toHaveBeenCalled()

        it "from csv data without user header", ->
            data.options.useColumnHeadersFromDataset = false

            @Data.meta.fileType = "csv"

            @Data.createVidatio data
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setHeader).not.toHaveBeenCalled()



