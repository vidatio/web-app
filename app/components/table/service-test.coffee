describe "Service Table", ->
    beforeEach ->
        module "app"

        inject (TableService) ->
            @Table = TableService

    it 'should set the dataset', ->
        # Needed for data binding
        expect(@Table.dataset.length).toEqual 1
        expect(@Table.dataset[0].length).toEqual 0

        dataset = [[20, 90], ["test", "test2"]]
        @Table.setDataset dataset
        expect(@Table.dataset.length).toEqual 2

        @Table.setDataset []
        expect(@Table.dataset.length).toEqual 1
        expect(@Table.dataset[0].length).toEqual 0

    it 'should set the dataset', ->
        dataset = [[20, 90], ["test", "test2"]]
        @Table.setDataset dataset
        @Table.resetDataset()

        expect(@Table.dataset.length).toEqual 1
        expect(@Table.dataset[0].length).toEqual 0

    it 'should take the first line of the dataset for the column headers', ->
        @Table.dataset = [["h1", "h2"], ["c1", "c2"]]
        @Table.takeColumnHeadersFromDataset()

        expect(@Table.dataset[0]).not.toContain "h1"
        expect(@Table.dataset[0]).toContain "c1"
