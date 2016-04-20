"use strict"

describe "Dataset Controller", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, $httpBackend) ->
            @httpBackend = $httpBackend
            @rootScope = $rootScope
            @scope = $rootScope.$new()
            @Visualization =
                downloadAsImage: (fileName, type) ->
            @Data =
                downloadCSV: ->
            @scope.data =
                title: "Filename"

            spyOn(@Visualization, "downloadAsImage")
            spyOn(@Data, "downloadCSV")

            DatasetCtrl = $controller "DatasetCtrl",  {$scope: @scope, $rootScope: @rootScope, VisualizationService: @Visualization, DataService: @Data}

    afterEach ->
        @Visualization.downloadAsImage.calls.reset()
        @Data.downloadCSV.calls.reset()

    describe "on clicked download PNG", ->
        it "should download the visualization in PNG-format", ->
            @scope.downloadVisualization("png")
            filename = @scope.data.title + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            expect(@Visualization.downloadAsImage).toHaveBeenCalledWith(filename, "png")

    describe "on clicked download JPEG", ->
        it "should download the visualization in JPEG-format", ->
            @scope.downloadVisualization("jpeg")
            filename = @scope.data.title + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            expect(@Visualization.downloadAsImage).toHaveBeenCalledWith(filename, "jpeg")

    describe "on clicked download CSV", ->
        it "should download the dataset in CSV-format", ->
            @scope.downloadCSV()
            expect(@Data.downloadCSV).toHaveBeenCalledWith(@scope.data.title)
