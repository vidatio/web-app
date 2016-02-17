"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "$log"
    ($log) ->
        class Table
            constructor: ->
                $log.info "TableService constructor called"

                @dataset = [[]]
                @useColumnHeadersFromDataset = true

                @colHeadersSelection = []
                @xAxisCurrent = ""
                @yAxisCurrent = ""

                @instanceTable = null

            initAxisSelection: ->
                $log.info "TableService initAxis called"

                colHeaders = @instanceTable.getColHeader()

                $log.debug
                    colHeaders: colHeaders

                @setColHeadersSelection colHeaders

            setXAxisCurrent: (column) ->
                $log.info "TableService setXAxisCurrent called"

                @xAxisCurrent = column

            setYAxisCurrent: (column) ->
                $log.info "TableService setYAxisCurrent called"

                @yAxisCurrent = column

            setColHeadersSelection: (colHeaders) ->
                $log.info "TableService setColHeaderSelection called"
                $log.debug
                    colHeaders: colHeaders

                @colHeadersSelection.splice 0, @colHeadersSelection.length
                colHeaders.forEach (item, index) =>
                    if item is null
                        item = ""
                    @colHeadersSelection[index] = item

            setInstance: (hot) ->
                $log.info "TableService setInstance called"

                @instanceTable = hot

            getInstance: ->
                $log.info "TableService getInstance called"

                return @instanceTable

            # @method reset
            # @public
            # @param {Boolean} useColumnHeadersFromDataset
            reset: (useColumnHeadersFromDataset) ->
                $log.info "TableService reset called"
                @resetDataset()
                # @useColumnHeadersFromDataset = useColumnHeadersFromDataset
                @resetColumnHeaders()

            # @method resetColumnHeaders
            # @public
            resetColumnHeaders: ->
                $log.info "TableService resetColumnHeaders called"

                console.log "@instanceTable", @instanceTable

                if @instanceTable
                    @instanceTable.updateSettings
                        colHeaders: true

                    @instanceTable.render()
                    @setColHeadersSelection @instanceTable.getColHeader()

            # @method setColumnHeaders
            # @public
            # @param {Array} columnHeaders
            setColumnHeaders: (columnHeaders) ->
                $log.info "TableService setColumnHeaders called"
                $log.debug
                    message: "TableService setColumnHeaders called"
                    columnHeaders: columnHeaders

                if @instanceTable
                    @instanceTable.updateSettings
                        colHeaders: columnHeaders

                    @instanceTable.render()
                    @setColHeadersSelection columnHeaders

            # @method takeColumnHeadersFromDataset
            # @public
            takeColumnHeadersFromDataset: ->
                $log.info "TableService takeColumnHeadersFromDataset called"
                columnHeaders = @dataset.splice(0, 1)[0]
                @setColumnHeaders columnHeaders

            # @method putColumnHeadersBackToDataset
            # @public
            putColumnHeadersBackToDataset: ->
                $log.info "TableService putColumnHeadersBackToDataset called"

                @dataset.unshift @instanceTable.getColHeader()
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

                @reset true
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
