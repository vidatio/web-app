"use strict"

describe "Service Data", ->

    beforeEach ->
        module "app"

        inject (DataService, ConverterService, TableService, MapService, $rootScope, $q, $injector) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()

            @Data = DataService
            @Converter = ConverterService

            @Map = MapService
            @Map.init @scope

            @Table = TableService
            @Table.getInstance = ->
            @Table.instanceTable =
                getColHeader: ->
                    return [0,1,2,3,4,5,5,6,7]

            spyOn(@Converter, "convertArrays2GeoJSON")
            spyOn(@Map, "setGeoJSON")
            spyOn(@Map, "updateGeoJSONWithSHP")

    it "should be defined and included", ->
        expect(@Data).toBeDefined()
        expect(@injector.has("DataService"))

    it "should have a meta object", ->
        expect(@Data.meta).toBeDefined()

    describe "should update Table and Map", ->
        it "with file type csv", ->
            @Data.meta.fileType = "csv"

            @Data.updateMap 0, 0, "oldData", "newData"

            expect(@Converter.convertArrays2GeoJSON).toHaveBeenCalled()
            expect(@Map.setGeoJSON).toHaveBeenCalled()

        it "with file type shp", ->
            @Data.meta.fileType = "shp"

            @Data.updateMap(0, 0, "oldData", "newData")
            expect(@Map.updateGeoJSONWithSHP).toHaveBeenCalled()



