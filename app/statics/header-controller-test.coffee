"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope) ->
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data =
                meta:
                    fileType: ""
                editorNotInitialized: ""
                dataset: [[]]
                saveViaAPI: (dataset) ->

            @Table =
                dataset: [["300", "Banana"], ["400", "Apple"], ["200", "Orange"]]
                getDataset: ->
                    [["0", "1"]]

            HeaderCtrl = $controller "HeaderCtrl", {$scope: @scope, DataService: @Data, TableService: @Table}

    describe "if editor was not initialized before", ->
        it "the datasets length should be 1 and data.editorNotInitialized should be true", ->
            expect(@Table.getDataset().length).toEqual(1)
            expect(@Data.editorNotInitialized).toBeDefined()
            expect(@Data.editorNotInitialized).toBeTruthy()
