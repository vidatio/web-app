"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "$log"
    ($log) ->
        class Table
            constructor: ->
                $log.info "TableService constructor called"

                @dataset = [[]]
                @columnHeaders = []
                @columnHeadersFromDataset = true

            resetColumnHeaders: ->
                $log.info "TableService resetColumnHeaders called"
                @columnHeaders.splice 0, @columnHeaders.length

                if !@columnHeadersFromDataset
                    # Because we want at least 26 columns we fill up the column headers
                    # TODO whats about datasets with more then 26 columns?
                    # Maybe use the width of the dataset + 1 for further free fields
                    for element in [ 0..25 ]
                        @columnHeaders[element] = String.fromCharCode(65 + element)

            setColumnHeaders: (columnHeaders) ->
                $log.info "TableService setColumnHeaders called"
                $log.debug
                    message: "TableService setColumnHeaders called"
                    columnHeaders: columnHeaders

                @resetColumnHeaders()

                # because we want to the keep the data binding
                # we can't assign the array, but we can exchange the items
                columnHeaders.forEach (item, index) =>
                    @columnHeaders[index] = item

            takeColumnHeadersFromDataset: ->
                $log.info "TableService takeColumnHeadersFromDataset called"
                columnHeaders = @dataset.splice(0, 1)[0]
                @setColumnHeaders columnHeaders
                @columnHeadersFromDataset = true

            putColumnHeadersBackToDataset: ->
                $log.info "TableService putColumnHeadersBackToDataset called"

                # Before removing column headers delivered by the dataset
                # we want to set them back to the rows inside the table
                if @columnHeadersFromDataset
                    # because we use data binding we can't unshift the array
                    # but we can push a new array with the items
                    tmp = []
                    @columnHeaders.forEach (item, index) ->
                        tmp[index] = item
                    @dataset.unshift tmp
                    @columnHeadersFromDataset = false

                @resetColumnHeaders()

            resetDataset: ->
                $log.info "TableService resetDataset called"

                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            setDataset: (data) ->
                $log.info "TableService setDataset called"
                $log.debug
                    message: "TableService setDataset called"
                    data: data

                @resetDataset()
                data.forEach (row, index) =>
                    @dataset[index] = row

            setCell: (row, column, data) ->
                $log.info "TableService setCell called"
                $log.debug
                    message: "TableService setCell called"
                    row: row
                    column: column
                    data: data

                @dataset[row][column] = data

            getDataset: ->
                $log.info "TableService getDataset called"

                return @dataset

        new Table
]
