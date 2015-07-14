describe "Service Table", ->

    beforeEach ->
        module "app"
        inject (TableService) ->
            @tableService = TableService

    it 'sets dataset', ->
        # handsontable needs for an empty table a object like [[]]
        expect(@tableService.dataset.length).toEqual 1

        fileContent = "90,180,description0\n90,-90,description1\n90,-180,description2"
        @tableService.setDataset fileContent

        expect(@tableService.dataset.length).toEqual 3
        expect(parseFloat(@tableService.dataset[0][0])).toEqual 90
        expect(@tableService.dataset[0][2]).toEqual "description0"
        expect(parseFloat(@tableService.dataset[2][1])).toEqual -180
        expect(@tableService.dataset[2][2]).toEqual "description2"
