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

    it 'should set a cell of the dataset', ->
        dataset = [[20, 90], ["test", "test2"]]
        @Table.setDataset dataset
        @Table.setCell(1, 1, 90)
        expect(@Table.dataset[1][1]).toEqual 90

    it 'should reset the column headers', ->
        @Table.columnHeaders = ["A", "B"]
        @Table.resetColumnHeaders()

        expect(@Table.columnHeaders).toEqual []
        expect(@Table.columnHeaders).not.toBe []

        @Table.columnHeaders = ["A", "B"]
        @Table.columnHeadersFromDataset = true
        @Table.resetColumnHeaders()

        expect(@Table.columnHeaders).toEqual []

        @Table.columnHeaders = ["test", "test"]
        @Table.columnHeadersFromDataset = false
        @Table.resetColumnHeaders()

        expect(@Table.columnHeaders).toContain "A"
        expect(@Table.columnHeaders).toContain "Z"
        expect(@Table.columnHeaders).not.toContain "A1"

    it 'should set the column headers', ->
        columnHeaders = ["test", "test"]
        @Table.setColumnHeaders columnHeaders

        expect(@Table.columnHeaders).toContain "test"
        expect(@Table.columnHeaders).not.toContain "A"

    it 'should take the first line of the dataset for the column headers', ->
        @Table.dataset = [["h1", "h2"], ["c1", "c2"]]
        @Table.takeColumnHeadersFromDataset()

        expect(@Table.columnHeaders).toEqual ["h1", "h2"]
        expect(@Table.columnHeaders).not.toContain "A"
        expect(@Table.dataset[0]).not.toContain "h1"
        expect(@Table.dataset[0]).toContain "c1"

    it 'should put the column headers back the the dataset', ->
        @Table.columnHeaders = ["h1", "h2"]
        @Table.dataset = [["c1", "c2"]]
        @Table.putColumnHeadersBackToDataset()

        expect(@Table.columnHeaders).toContain "A"
        expect(@Table.columnHeaders).toContain "Z"
        expect(@Table.columnHeaders).not.toContain "h1"
        expect(@Table.dataset[0]).toContain "h1"
        expect(@Table.dataset[0]).not.toContain "c1"
