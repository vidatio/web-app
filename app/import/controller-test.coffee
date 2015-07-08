
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

###
describe "Controller Import", ->
    describe "read file via link", ->
        scope = undefined
        httpBackend = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $httpBackend) ->
                httpBackend = $httpBackend
                scope = $rootScope.$new()

                DataTable =
                    dataset: []
                    setDataset: (data) ->

                ImportCtrl = $controller "ImportCtrl", $scope: scope,


        it 'should get the content of a file', ->
            httpBackend.whenGET('/v0/upload?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            scope.link = 'test.txt'
            scope.load()
            httpBackend.flush()
            expect(DataTable.dataset).toEqual [
                ['test', '1']
                ['test', '2']
                ['test', '3']
            ]





describe 'Controller Import', ->

    describe 'read file via link', ->
        scope = undefined
        httpBackend = undefined
        DataTable = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $httpBackend, DataTableService) ->
                httpBackend = $httpBackend
                scope = $rootScope.$new()
                FileReadCtrl = $controller "FileReadCtrl", $scope: scope
                DataTable = DataTableService

        it 'should get the content of a file', ->
            httpBackend.whenGET('/api?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            scope.link = 'test.txt'
            scope.load()
            httpBackend.flush()
            expect(DataTable.dataset).toEqual [
                ['test','1']
                ['test','2']
                ['test','3']
            ]

    describe 'reading file should end in set dataset of DataTable service', ->
        scope = undefined
        httpBackend = undefined
        DataTable = undefined

        beforeEach module('vidatio')

        beforeEach inject(($rootScope, $controller, $httpBackend, DataTableService) ->
            httpBackend = $httpBackend
            scope = $rootScope.$new()
            $controller 'FileReadCtrl', $scope: scope
            DataTable = DataTableService
        )

        it 'should get the content of a file', ->
            httpBackend.whenGET('/api?url=test.txt').respond 'test,1\ntest,2\ntest,3'
            scope.link = 'test.txt'
            scope.load()
            httpBackend.flush()
            expect(DataTable.dataset).toEqual [
                ['test','1']
                ['test','2']
                ['test','3']
            ]
###
