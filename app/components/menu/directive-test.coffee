# File Reader Directive Test
# =================

"use strict"

xdescribe "Directive Menu", ->
    describe "menu", ->
        beforeEach ->
            module "app"
            inject ($rootScope, $controller, $compile, $injector) ->
                @injector = $injector
                @scope = $rootScope.$new()
                @element = $compile('<menu></menu>')(@scope)

                @UserService =
                    logout: ->

                #@scope = @element.scope()
                #console.log(@element.isolateScope())

                spyOn(@scope, "logout")
                spyOn(@UserService, 'logout')

        it "should exist in the injector", ->
            expect(@injector.has('menuDirective')).toBeTruthy()

        it "should listen to the change event", ->
            @scope.logout()
            expect(@UserService.logout).toHaveBeenCalled()

        afterEach ->
            @UserService.logout.calls.reset()
            #@scope.logout.calls.reset()
