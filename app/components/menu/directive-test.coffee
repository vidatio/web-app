"use strict"

# TODO
# Because the $scope.logout functions contains state.go calls this should be a e2e test

xdescribe "Directive Menu", ->
    describe "menu", ->
        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile, $injector, UserService, $httpBackend) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @httpBackend = $httpBackend

                @element = $compile('<menu></menu>')(@scope)
                @scope.$digest()

                @User = UserService

                spyOn(@element.scope(), "logout")
                spyOn(@UserService, 'logout')

        it "should exist in the injector", ->
            expect(@injector.has('menuDirective')).toBeTruthy()

        it "should listen to the change event", ->
            @element.scope().logout()
            expect(@User.logout).toHaveBeenCalled()

        afterEach ->
            @User.logout.calls.reset()
            @element.scope().logout.calls.reset()
