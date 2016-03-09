"use strict"

describe "Dataset Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Table =
                setDataset: (result) ->
            @Data =
                createVidatio: (data) ->

            DatasetCtrl = $controller "DatasetCtrl",  {$scope: @scope, $rootScope: @rootScope, TableService: @Table, DataService: @Data}

    # describe "on clicked createVidatio", ->
    #     it "should redirect to editor-page and set the data from the current Vidatio using Table.setDataset", ->
    #         @httpBackend.whenGET(/index/).respond ""
    #         @httpBackend.whenGET(/editor/).respond ""
    #         @httpBackend.expectGET(/languages/).respond ""

    #         @scope.data = []
    #         # Data.meta["fileType"] is "shp"
    #         # console.log "@Data.meta", @Data.meta
    #         # console.log "@Data.meta.fileType", @Data.meta.fileType

    #         spyOn(@Data, "createVidatio")
    #         # console.log "@scope.createVidatio()", @scope.createVidatio()
    #         @scope.createVidatio()
    #         expect(@Data.createVidatio).toHaveBeenCalled()

    describe "on clicked getLink-button", ->
        it "should show the Vidatio-link box including the link to the current Vidatio on click at link-button", ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.toggleVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(true)

            @scope.toggleVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(false)

    describe "on clicked close-cross in link-box", ->
        it "should hide the Vidatio-link box on click at the cross", ->
            @httpBackend.whenGET(/index/).respond ""
            @httpBackend.whenGET(/editor/).respond ""
            @httpBackend.expectGET(/languages/).respond ""

            @scope.hideVidatioLink()
            expect(@rootScope.showVidatioLink).toEqual(false)
