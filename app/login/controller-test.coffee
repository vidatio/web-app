"use strict"

describe "Controller Login", ->
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

    describe "on logon", ->
        it 'should call logon of the UserService', ->
            @scope.user =
                name: "test"
                password: "geheim"

            @scope.logon()

            expect(@UserService.logon).toHaveBeenCalled()
            expect(@UserService.logon).toHaveBeenCalledWith(@scope.user.name, @scope.user.password)
