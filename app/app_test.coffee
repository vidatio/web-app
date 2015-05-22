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

        it "should have a registered 'ngRoute' dependency", ->
            expect( hasModule("ngRoute") ).toBeTruthy()

        it "should have a registered 'ngAnimate' dependency", ->
            expect( hasModule("ngAnimate") ).toBeTruthy()

        it "should have a registered 'ngResource' dependency", ->
            expect( hasModule("ngResource") ).toBeTruthy()

        it "should have a registered 'ui.bootstrap' dependency", ->
            expect( hasModule("ui.bootstrap") ).toBeTruthy()

        it "should have a registered 'app.controllers' dependency", ->
            expect( hasModule("app.controllers") ).toBeTruthy()

        it "should have a registered 'app.services' dependency", ->
            expect( hasModule("app.services") ).toBeTruthy()

        it "should have a registered 'app.directives' dependency", ->
            expect( hasModule("app.directives") ).toBeTruthy()

