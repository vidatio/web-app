"use strict"

describe "Header Controller", ->
    beforeEach ->

        module "app"

        inject ($controller, $rootScope, $httpBackend, DataService) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data = DataService

            HeaderCtrl = $controller "HeaderCtrl", {$scope: @scope, $rootScope: @rootScope, DataService: @Data}

    describe "on save vidatio-title if title input-field is empty", ->
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
        @scope.vidatioTitle = "Vidatio created a diagramm for me"
        @scope.standardTitle = "My Vidatio"

        @scope.saveVidatioTitle()
        expect(@Data.meta.fileName).toBeDefined()
        expect(@Data.meta.fileName).toEqual("Vidatio created a diagramm for me")
