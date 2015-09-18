describe "Service Table", ->
    beforeEach ->
        module "app"
        inject (TableService, $injector) ->
            @TableService = TableService
            @Converter = $injector.get("ConverterService")
            @Map = $injector.get("MapService")

            @Converter.convertArrays2GeoJSON = ->
            @Map.setGeoJSON = ->

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

    it 'should set the dataset', ->
        dataset = [[20,90], ["test", "test2"]]
        @TableService.setDataset dataset
        @TableService.reset()

        expect(@TableService.dataset.length).toEqual 1
        expect(@TableService.dataset[0].length).toEqual 0

        # TODO: tests if MapService and ConverterService gets called

    it 'should set a cell of the dataset', ->
        dataset = [[20,90], ["test", "test2"]]
        @TableService.setDataset dataset
        @TableService.setCell(1,1,90)
        expect(@TableService.dataset[1][1]).toEqual 90

        # TODO: tests if MapService and ConverterService gets called
