"use strict"

describe "Controller Registration", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $q, $log) ->
            @scope = $rootScope.$new()
            @rootScope = $rootScope
            @deferred = $q.defer()

            @UserFactory =
                save: (user) ->

            spyOn(@UserFactory, 'save').and.returnValue(@deferred.promise)
            RegistrationCtrl = $controller "RegistrationCtrl", $scope: @scope, UserFactory: @UserFactory, $rootScope: @rootScope, $log: $log

    afterEach ->
        @UserFactory.save.calls.reset()

    describe "on register", ->
        it 'should call save of the UserFactory', ->
            @scope.user =
                email: "test@test.com"
                name: "test"
                password: "test"

            @scope.register()

            expect(@UserFactory.save).toHaveBeenCalled()
            expect(@UserFactory.save.calls.argsFor(0)[0]).toEqual(@scope.user)



