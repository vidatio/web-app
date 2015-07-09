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
    q = undefined
    Table = undefined
    Import = undefined

    beforeEach ->
        module "app"
        inject ($controller, $rootScope, $httpBackend, $q) ->
            httpBackend = $httpBackend
            scope = $rootScope.$new()
            q = $q.defer()

            # Stubs for the controller allow to spy on the service calls
            Table =
                dataset: []
                setDataset: ->
            Import =
                readFile: ->
                    return q.promise

            spyOn(Import, 'readFile')#.and.returnValue(q.promise)
            spyOn(Table, 'setDataset')

            ImportCtrl = $controller "ImportCtrl", $scope: scope, TableService: Table, ImportService: Import

    describe "on upload via link", ->
        ###it 'should set the dataset of the table', ->
            httpBackend.whenGET('http://localhost:9876/v0/import?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            scope.link = 'test.txt'
            scope.load()
            httpBackend.flush()

            expect(Table.setDataset).toHaveBeenCalled()
            expect(Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
        ###
    afterEach ->
        Import.readFile.reset()
        Table.setDataset.reset()


### describe "on upload via browse and drag and drop", ->
     it 'should read the file via the ImportService', ->
         scope.file = "test.txt"
         scope.getFile()

         expect(Import.readFile).toHaveBeenCalled()
         expect(Import.readFile).toHaveBeenCalledWith(scope.file)

     it 'should set the dataset of the table after reading the file', ->
         scope.file = "test.txt"
         scope.getFile()
         q.resolve()

         expect(Table.setDataset).toHaveBeenCalled()
         expect(Table.setDataset).toHaveBeenCalledWith 'test,1\ntest,2\ntest,3'
 ###
