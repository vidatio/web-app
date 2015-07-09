"use strict"

describe "Controller Import", ->
    beforeEach ->
        module "app"
        inject ($controller, $rootScope, $httpBackend, $q, $http) ->
            @httpBackend = $httpBackend
            @scope = $rootScope.$new()

            @deferred = $q.defer()

            @Table =
                setDataset: (result) ->
            @Import =
                readFile: (file, scope) ->

            spyOn(@Import, 'readFile').and.returnValue(@deferred.promise)
            spyOn(@Table, 'setDataset')

            ImportCtrl = $controller "ImportCtrl", $scope: @scope, $http: $http, TableService: @Table, ImportService: @Import

    afterEach ->
        @Import.readFile.calls.reset()
        @Table.setDataset.calls.reset()

    describe "on upload via link", ->
        it 'should set the dataset of the table', ->
            @httpBackend.whenGET('/v0/import?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            @scope.link = 'test.txt'
            @scope.load()
            @httpBackend.flush()

            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'

    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            @scope.file = "test.txt"
            @scope.getFile()

            expect(@Import.readFile).toHaveBeenCalled()
            expect(@Import.readFile).toHaveBeenCalledWith(@scope.file, @scope)

        xit 'should set the dataset of the table after reading the file', ->
            @scope.file = "test.txt"
            @scope.getFile()
            @deferred.resolve('test,1\ntest,2\ntest,3')

            # TODO: Check if test is necessary, because this it is not testable
            expect(@Table.setDataset).toHaveBeenCalled()
            expect(@Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
