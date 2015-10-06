"use strict"

describe "Service Data", ->
    beforeEach ->
        module "app"
        inject (DataService, ConverterService, MapService, $rootScope, $q, $injector) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()

            @Data = DataService
            @Converter = ConverterService
            @Map = MapService

            spyOn(@Converter, "convertArrays2GeoJSON")
            spyOn(@Map, "setGeoJSON")
            spyOn(@Map, "updateGeoJSONwithSHP")

    it "should be defined and included", ->
        expect(@Data).toBeDefined()
        expect(@injector.has("DataService"))

    it "should have a meta object", ->
        expect(@Data.meta).toBeDefined()

    describe "should update Table and Map", ->
        it "with file type csv", ->
            @Data.meta.fileType = "csv"

            @Data.updateTableAndMap 0, 0, "oldData", "newData"

            expect(@Converter.convertArrays2GeoJSON).toHaveBeenCalled()
            expect(@Map.setGeoJSON).toHaveBeenCalled()

        it "with file type shp", ->
            @Data.meta.fileType = "shp"

            @Data.updateTableAndMap(0, 0, "oldData", "newData")
            expect(@Map.updateGeoJSONwithSHP).toHaveBeenCalled()



