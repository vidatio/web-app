"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data =
                datasetID: ""
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

            $httpBackend.when('GET', 'languages/de.json').respond({})
            $httpBackend.when('GET', '404/404.html').respond({})
            $httpBackend.when('GET', 'index/index.html').respond({})

    describe "if editor was not initialized before", ->
        it "the datasets length should be 1 and data.editorNotInitialized should be true", ->
            @Data.datasetID = "test"
            @scope.$apply()

            expect(@Table.getDataset().length).toEqual(1)
            expect(@Data.editorNotInitialized).toBeDefined()
            expect(@Data.editorNotInitialized).toBeTruthy()
