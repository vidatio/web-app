"use strict"

describe "Editor Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend, DataService, $compile) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Data = DataService
            @compile = $compile
            @inputElement = angular.element('<div class="title"><input type="text" id="vidatio-title" ng-change="saveVidatioTitle()" ng-model="editor.name"></input></div>')

            EditorCtrl = $controller "EditorCtrl",  {$scope: @scope, $rootScope: @rootScope, DataService: @Data}

    describe "on clicked tab", ->
        it "should set the showTableView and showVisualizationView variables accordingly", ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.tabClicked(0)
            expect(@rootScope.showTableView).toBeTruthy()
            expect(@rootScope.showVisualizationView).toBeFalsy()
            expect(@scope.activeViews).toEqual(1)

            @scope.tabClicked(1)
            expect(@rootScope.showTableView).toBeTruthy()
            expect(@rootScope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(2)

            @scope.tabClicked(2)
            expect(@rootScope.showTableView).toBeFalsy()
            expect(@rootScope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(1)

    describe "on save vidatio-title if title input-field is not filled up", ->
        it "should set Data.name according to a predefined standard title", ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @Data.name = ""
            @scope.vidatioTitle = ""
            @scope.standardTitle = "My Vidatio"

            @scope.saveVidatioTitle()
            expect(@Data.name).toBeDefined()
            expect(@Data.name).toBe("My Vidatio")

    describe "on save vidatio-title if title input-field is filled up", ->
        it "should set Data.name according to the text in the title input field", ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @Data.name = ""

            @compile(@inputElement) @scope
            @scope.$digest()

            @inputElementInput = @inputElement.find("input")

            angular.element(@inputElementInput).val("I created my first Vidatio").trigger "input"
            @scope.$apply()

            expect(@Data.name).toBeDefined()
            expect(@Data.name).toBe("I created my first Vidatio")
            #expect(@scope.setTitleInputWidth).toHaveBeenCalled()
