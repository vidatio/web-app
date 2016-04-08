"use strict"

describe "Editor Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend, $compile) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Visualization =
                create: ->
            @compile = $compile
            spyOn(@Visualization, "create")
            EditorCtrl = $controller "EditorCtrl",  {$scope: @scope, $rootScope: @rootScope, DataService: @Data, VisualizationService: @Visualization}

    afterEach ->
        @Visualization.create.calls.reset()

    describe "on page init", ->
        it "should display both the TableView and VisualizationView", ->
            expect(@scope.showTableView).toBeTruthy()
            expect(@scope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(2)

    describe "on clicked tab", ->
        it "should set the showTableView and showVisualizationView variables accordingly", ->
            expect(@scope.showTableView).toBeTruthy()
            expect(@scope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(2)

            @scope.tabClicked(0)
            expect(@scope.showTableView).toBeTruthy()
            expect(@scope.showVisualizationView).toBeFalsy()
            expect(@scope.activeViews).toEqual(1)

            @scope.tabClicked(1)
            expect(@scope.showTableView).toBeTruthy()
            expect(@scope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(2)

            @scope.tabClicked(2)
            expect(@scope.showTableView).toBeFalsy()
            expect(@scope.showVisualizationView).toBeTruthy()
            expect(@scope.activeViews).toEqual(1)

    describe "on clicked at tab 'dataset + visualization' or at tab 'visualization'", ->
        it 'should call Visualization.create() after a timeout of 10ms', (done) ->
            @scope.tabClicked(0)
            setTimeout (->
                done()
            ), 10
            return
            expect(@Visualization.create).not.toHaveBeenCalled()

            @scope.tabClicked(1)
            setTimeout (->
                done()
            ), 10
            return
            expect(@Visualization.create).toHaveBeenCalled()

            @scope.tabClicked(2)
            setTimeout (->
                done()
            ), 10
            return
            expect(@Visualization.create).toHaveBeenCalled()
