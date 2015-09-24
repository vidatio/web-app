# App Test
# ========
"use strict"

describe "testing app modules: ", ->

    app_module = undefined
    deps = undefined

    hasModule = ( module_name ) ->
        return deps.indexOf( module_name ) >= 0

    describe "testing app module dependencies", ->

        beforeEach ->
            app_module = angular.module "app"
            deps = app_module.value( "app" ).requires


        it "should be registered", ->
            expect( app_module ).toBeDefined()

        it "should have a registered 'app.controllers' dependency", ->
            expect( hasModule("app.controllers") ).toBeTruthy()

        it "should have a registered 'app.services' dependency", ->
            expect( hasModule("app.services") ).toBeTruthy()

        it "should have a registered 'app.directives' dependency", ->
            expect( hasModule("app.directives") ).toBeTruthy()

        it "should have a registered 'app.config' dependency", ->
            expect( hasModule("app.config") ).toBeTruthy()

describe "should check app.config module", ->

    beforeEach ->
        module('app.config')

    it "to be present", ->
        testFixture = undefined
        inject (_CONFIG_) ->
            testFixture = _CONFIG_

        expect(testFixture).toEqual(
            CONFIG:
                ENV: ""
        )

