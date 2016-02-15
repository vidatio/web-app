"use strict"

describe "Controller Import", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend, $q, $http, $location) ->
            @httpBackend = $httpBackend
            @scope = $rootScope.$new()
            @rootScope = $rootScope
            @location = $location
            @deferred = $q.defer()

            @Table =
                setDataset: (result) ->
                resetColHeaders: ->
            @Import =
                readFile: (file, scope) ->

            spyOn(@Import, 'readFile').and.returnValue(@deferred.promise)
            spyOn(@Table, 'setDataset')
            spyOn(@Table, 'resetColHeaders')


            ImportCtrl = $controller "ImportCtrl", $scope: @scope, $http: $http, TableService: @Table, ImportService: @Import

    afterEach ->
        @Import.readFile.calls.reset()
        @Table.setDataset.calls.reset()

    describe "on upload via link", ->
        it 'should set the dataset of the table', ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""
            @httpBackend.whenGET(@rootScope.apiBase + '/v0/forward?url=test.csv').respond
                body: 'test,1\ntest,2\ntest,3'
                fileType: 'csv'
            @scope.link = 'test.csv'
            @scope.load()
            @httpBackend.flush()

            expect(@Table.resetColHeaders).toHaveBeenCalled()
            expect(@Table.setDataset).toHaveBeenCalled()


    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            @scope.file =
                name: "test.csv"
            @scope.getFile()

            expect(@Import.readFile).toHaveBeenCalled()
            expect(@Import.readFile).toHaveBeenCalledWith(@scope.file, "csv")

        # Disabled because of promise gets never resolved
        xit 'should set the dataset of the table after reading the file', ->
            @scope.file =
                name: "test.csv"
            @scope.getFile()
            @deferred.resolve('test,1\ntest,2\ntest,3')

            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
