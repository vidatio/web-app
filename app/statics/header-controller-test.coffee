"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend, DataService, $compile) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data = DataService
            @compile = $compile
            @inputElement = angular.element('<div class="title"><input type="text" id="vidatio-title" ng-change="saveVidatioTitle()" ng-model="vidatioTitle"></input></div>')

            HeaderCtrl = $controller "HeaderCtrl", {$scope: @scope, $rootScope: @rootScope, DataService: @Data}

    describe "on save vidatio-title if title input-field is not filled up", ->
    it "should set the Data.meta.filename according to a predefined standard title", ->
        @httpBackend.whenGET(/index/).respond ""
        @httpBackend.whenGET(/editor/).respond ""
        @httpBackend.expectGET(/languages/).respond ""

        @Data.meta.fileName = ""
        @scope.vidatioTitle = ""
        @scope.standardTitle = "My Vidatio"

        @scope.saveVidatioTitle()
        expect(@Data.meta.fileName).toBeDefined()
        expect(@Data.meta.fileName).toEqual("My Vidatio")


    describe "on save vidatio-title if title input-field is filled up", ->
    it "should set the Data.meta.filename according to the text in the title input field", ->
        @httpBackend.whenGET(/index/).respond ""
        @httpBackend.whenGET(/editor/).respond ""
        @httpBackend.expectGET(/languages/).respond ""

        @Data.meta.fileName = ""

        @compile(@inputElement) @scope
        @scope.$digest()

        @inputElementInput = @inputElement.find("input")

        angular.element(@inputElementInput).val("I created my first Vidatio").trigger "input"
        @scope.$apply()

        expect(@Data.meta.fileName).toBeDefined()
        expect(@Data.meta.fileName).toBe("I created my first Vidatio")
