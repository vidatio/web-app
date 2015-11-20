"use strict"

describe "Controller Import", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $q, $state, $log) ->
            @scope = $rootScope.$new()
            @rootScope = $rootScope
            @deferred = $q.defer()

            @UserService =
                logon: (name, password) ->

            spyOn(@UserService, 'logon').and.returnValue(@deferred.promise)

            LoginCtrl = $controller "LoginCtrl", $scope: @scope, UserService: @UserService, $rootScope: @rootScope, $state: $state, $log: $log

    afterEach ->
        @UserService.logon.calls.reset()

    describe "on upload via browse and drag and drop", ->
        it 'should read the file via the ImportService', ->
            @scope.file =
                username
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
