# what to test:
#  load:
#   - check HTTP request at load
#   - DataTable set dataset at success HTTP request
#   - correct data

# getFile
#   - readFile called
#   - readFile returns promise
#   - setDataset called (called when readFile is finished)

"use strict"

describe "Controller Import", ->
    scope = undefined
    httpBackend = undefined
    deferred = undefined
    Table = undefined
    Import = undefined
    rootScope = undefined

    beforeEach ->
        module "app"
        inject ($controller, $rootScope, $httpBackend, $q, $http) ->
            httpBackend = $httpBackend
            rootScope = $rootScope
            scope = $rootScope.$new()

            deferred = $q.defer()

            Table =
                dataset: []
                setDataset: ->
            Import =
                readFile: (file, scope) ->

            spyOn(Import, 'readFile').and.returnValue(deferred.promise)
            spyOn(Table, 'setDataset')

            ImportCtrl = $controller "ImportCtrl", $scope: scope, $http: $http, TableService: Table, ImportService: Import

    describe "on upload via link", ->
        it 'should set the dataset of the table', ->
            httpBackend.whenGET('/v0/import?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            scope.link = 'test.txt'
            scope.load()
            httpBackend.flush()

            expect(Table.setDataset).toHaveBeenCalled()
            expect(Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'

    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            scope.file = "test.txt"
            scope.getFile()

            expect(Import.readFile).toHaveBeenCalled()

    afterEach ->
        Import.readFile.calls.reset()
        Table.setDataset.calls.reset()

###
     it 'should set the dataset of the table after reading the file', ->
         scope.file = "test.txt"
         scope.getFile()
         q.resolve()

         expect(Table.setDataset).toHaveBeenCalled()
         expect(Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
 ###
