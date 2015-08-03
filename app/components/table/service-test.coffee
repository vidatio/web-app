describe "Service Table", ->

    beforeEach ->
        module ($provide) ->

            $provide.service "MapService", ->
                @setGeoJSON = jasmine.createSpy("setGeoJSON").and.callFake( -> return
                )

            $provide.service "ConverterService", ->
                @convertArrays2GeoJSON = jasmine.createSpy("convertArrays2GeoJSON").and.callFake( ->
                    return "geoJSON"
                )
            return null
        module "app"

        inject (TableService, MapService, ConverterService) ->
            @TableService = TableService
            @MapService = MapService
            @ConverterService = ConverterService

            spyOn(@MapService, "setGeoJSON")
            spyOn(@ConverterService, "convertArrays2GeoJSON")

    it 'should set the dataset', ->
        # Needed for data binding
        expect(@TableService.dataset.length).toEqual 1
        expect(@TableService.dataset[0].length).toEqual 0

        dataset = [[20,90], ["test", "test2"]]
        @TableService.setDataset dataset
        expect(@TableService.dataset.length).toEqual 2

        @TableService.setDataset []
        expect(@TableService.dataset.length).toEqual 1
        expect(@TableService.dataset[0].length).toEqual 0

    xit 'should set the dataset', ->
        #console.log mapService

        dataset = [[20,90], ["test", "test2"]]
        @TableService.setDataset dataset
        @TableService.reset()

        expect(@TableService.dataset.length).toEqual 1
        expect(@TableService.dataset[0].length).toEqual 0

        expect(@MapService.setGeoJSON).toHaveBeenCalled()

        #expect(@MapService.setGeoJSON).toHaveBeenCalledWith "geoJSON"

        expect(@ConverterService.convertArrays2GeoJSON).toHaveBeenCalled()
        expect(@ConverterService.convertArrays2GeoJSON).toHaveBeenCalledWith(@TableService.dataset)
        # TODO: tests if MapService and ConverterService gets called

    xit 'should set a cell of the dataset', ->
        dataset = [[20,90], ["test", "test2"]]
        @TableService.setDataset dataset
        @TableService.setCell(1,1,90)
        expect(@TableService.dataset[1][1]).toEqual 90

        expect(@MapService.setGeoJSON).toHaveBeenCalled()

        expect(@ConverterService.convertArrays2GeoJSON).toHaveBeenCalled()
        expect(@ConverterService.convertArrays2GeoJSON).toHaveBeenCalledWith(@TableService.dataset)
        # TODO: tests if MapService and ConverterService gets called
