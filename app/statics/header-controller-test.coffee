"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend, DataService, MapService) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data =
                meta:
                    fileType: ""
                editorNotInitialized: ""
                dataset: [[]]

                saveViaAPI: (dataset) ->

            @Table =
                dataset: [["300", "Banane"], ["400", "Apfel"], ["200", "Orange"]]

                getDataset: ->
                    [["0", "1"]]

            @Map =
                getGeoJSON: ->

            spyOn(@Map, "getGeoJSON")
            spyOn(@Data, "saveViaAPI")

            HeaderCtrl = $controller "HeaderCtrl", {$scope: @scope, $rootScope: @rootScope, DataService: @Data, TableService: @Table, MapService: @Map}

    afterEach ->
        @Map.getGeoJSON.calls.reset()
        @Data.saveViaAPI.calls.reset()


    describe "if editor was not initialized before", ->
        it "the datasets length should be 1 and data.editorNotInitialized should be true", ->
            expect(@Table.getDataset().length).toEqual(1)
            expect(@Data.editorNotInitialized).toBeDefined()
            expect(@Data.editorNotInitialized).toBeTruthy()

    describe "on saveDataset", ->
        it "the datasets' name should have been set to users' input or to a standard-title including current time of day", ->

            @scope.header.name = "Vidatio test diagramm"

            @scope.saveDataset()
            expect(@scope.header.name).toBe("Vidatio test diagramm")

            @scope.standardTitle = "Vidatio test diagramm"
            @scope.saveDataset()
            expect(@scope.header.name).toBe(@scope.standardTitle + " " + moment().format("HH_mm_ss"))

    describe "on saveDataset", ->
        it "if fileType is 'shp' then Map.getGeoJSON and Data.saveViaAPI should have been called", ->
            @scope.header.meta.fileType = "shp"

            @scope.saveDataset()
            expect(@Map.getGeoJSON).toHaveBeenCalled()
            expect(@Data.saveViaAPI).toHaveBeenCalled()

    describe "on saveDataset", ->
        it "if fileType is 'csv' then the dataset should have been sliced and Data.saveViaAPI called", ->
            @scope.header.meta.fileType = "csv"
            testDataset = [["300", "Banane"], ["400", "Apfel"], ["200", "Orange"]]

            @scope.saveDataset()
            expect(@Table.dataset.slice()).toEqual(testDataset)
            expect(@Data.saveViaAPI).toHaveBeenCalledWith(testDataset)
