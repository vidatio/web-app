describe "Embedding Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @stateParams = {}
            @state =
                go: (state) ->

            spyOn(@state, "go")

            EmbeddingCtrl = $controller "EmbeddingCtrl",  {$scope: @scope, $rootScope: @rootScope, $stateParams: @stateParams, $state: @state}

    afterEach ->
        @state.go.calls.reset()

    describe "on enter embedding-page without proper embeddingID", ->
        it "should redirect to 404-page", ->
            expect(@state.go).toHaveBeenCalledWith("app.fourofour")
