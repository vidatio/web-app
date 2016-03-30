"use strict"

describe "Login / Register Directive", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $q, $state, $log) ->
            @scope = $rootScope.$new()
            @rootScope = $rootScope
            @deferred = $q.defer()

            @UserFactory =
                save: (user) ->

            @UserService =
                logon: (name, password) ->

            spyOn(@UserService, 'logon').and.returnValue(@deferred.promise)
            spyOn(@UserFactory, 'save').and.returnValue(@deferred.promise)

            LoginCtrl = $controller "LoginCtrl", $scope: @scope, UserService: @UserService, $rootScope: @rootScope, $state: $state, $log: $log, UserFactory: @UserFactory

            @scope.user =
                email: "test@test.com"
                name: "test"
                password: "test"

    afterEach ->
        @UserService.logon.calls.reset()
        @UserFactory.save.calls.reset()

    describe "on logon", ->
        it 'should call logon of the UserService', ->
            @scope.logon()

            expect(@UserService.logon).toHaveBeenCalled()
            expect(@UserService.logon).toHaveBeenCalledWith(@scope.user)

    describe "on register", ->
        it 'should call save of the UserFactory', ->
            @scope.register()

            expect(@UserFactory.save).toHaveBeenCalled()
            expect(@UserFactory.save.calls.argsFor(0)[0]).toEqual(@scope.user)
