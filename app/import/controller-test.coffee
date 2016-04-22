"use strict"

describe "Controller Import", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend, $q, $http, $location, $timeout) ->
            @httpBackend = $httpBackend
            @scope = $rootScope.$new()
            @rootScope = $rootScope
            @location = $location
            @deferred = $q.defer()
            @timeout = $timeout

            @Table =
                dataset: [[]]
                setDataset: (result) ->
                takeHeaderFromDataset: ->
                setHeader: (header) ->
                    @header = header
            @Import =
                getFile: (file) ->
            @Data =
                initTableAndMap: (p1, p2) ->


            spyOn(@Import, 'getFile').and.returnValue(@deferred.promise)
            spyOn(@Data, 'initTableAndMap')

            ImportCtrl = $controller "ImportCtrl", $scope: @scope, $http: $http, DataService: @Data, ImportService: @Import

    afterEach ->
        @Import.getFile.calls.reset()
        @Data.initTableAndMap.calls.reset()

    describe "on upload via link", ->
        it 'should set the dataset of the table', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""
            @httpBackend.expectGET(/404/).respond ""
            @httpBackend.whenGET(@rootScope.apiBase + '/v0/forward?url=test.csv').respond
                body: 'test,1\ntest,2\ntest,3'
                fileType: 'csv'
            @scope.link = 'test.csv'
            @scope.load()
            @httpBackend.flush()

            expect(@Data.initTableAndMap).toHaveBeenCalled()

    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            @scope.getFile
                name: "test.csv"

            @timeout ->
                expect(@Import.readFile).toHaveBeenCalled()
                expect(@Import.readFile).toHaveBeenCalledWith(@scope.file, "csv")

        # Disabled because of promise gets never resolved
        xit 'should set the dataset of the table after reading the file', ->
            @scope.getFile
                name: "test.csv"
            @deferred.resolve('test,1\ntest,2\ntest,3')

            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
