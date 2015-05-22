# Home Controller Test
# ====================

"use strict"

describe "Testing home controller", ->

    HomeCtrl = undefined
    $scope = undefined

    beforeEach ->
        module "app"
        inject ($controller, $rootScope) ->
            $scope = $rootScope.$new()
            HomeCtrl = $controller "HomeCtrl", $scope: $scope


    it "should be present", ->
        expect( HomeCtrl ).toBeDefined()

    it "should have an 'loginData' object", ->
        expect( $scope.loginData ).toBeDefined()
        expect( $scope.loginData ).toEqual jasmine.any(Object)

    it "should have an 'alerts' object", ->
        expect( $scope.alerts ).toBeDefined()
        expect( $scope.alerts ).toEqual jasmine.any(Object)

    it "should have have a login array within the 'alerts' object", ->
        expect( $scope.alerts.login ).toBeDefined()
        expect( $scope.alerts.login ).toEqual jasmine.any(Array)

    describe "function login", ->
        it "should be present", ->
            expect( $scope.login ).toBeDefined()
            expect( $scope.login ).toEqual jasmine.any(Function)
