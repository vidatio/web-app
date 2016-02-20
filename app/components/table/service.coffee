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
                @instanceTable = null

            initAxisSelection: ->
                $log.info "TableService initAxis called"

                colHeaders = @instanceTable.getColHeader()
                $log.debug
                    colHeaders: colHeaders

                @setColHeadersSelection colHeaders

            setColHeadersSelection: (colHeaders) ->
                $log.info "TableService setColHeaderSelection called"
                $log.debug
                    colHeaders: colHeaders

                @colHeadersSelection.splice 0, @colHeadersSelection.length
                colHeaders.forEach (item, index) =>
                    if item is null
                        return
                    @colHeadersSelection[index] = item

            setInstance: (hot) ->
                $log.info "TableService setInstance called"
                @instanceTable = hot

            getInstance: ->
                $log.info "TableService getInstance called"
                return @instanceTable

            getColumnHeaders: ->
                $log.info "TableService getColumnHeaders called"

                if @useColumnHeadersFromDataset
                    return @instanceTable.getColHeader()
                else
                    return []

            # @method reset
            # @public
            # @param {Boolean} useColumnHeadersFromDataset
            reset: ->
                $log.info "TableService reset called"
                @resetDataset()
                @resetColumnHeaders()

            # @method resetColumnHeaders
            # @public
            resetColumnHeaders: ->
                $log.info "TableService resetColumnHeaders called"

                if @instanceTable
                    @useColumnHeadersFromDataset = false
                    @instanceTable.updateSettings
                        colHeaders: true
                    @instanceTable.render()
                    @setColHeadersSelection @instanceTable.getColHeader()
                else
                    $log.error "TableService setColumnHeaders instanceTable is not defined"

            # @method setColumnHeaders
            # @public
            # @param {Array} columnHeaders
            setColumnHeaders: (columnHeaders) ->
                $log.info "TableService setColumnHeaders called"
                $log.debug
                    message: "TableService setColumnHeaders called"
                    columnHeaders: columnHeaders

                if @instanceTable
                    @useColumnHeadersFromDataset = true
                    @instanceTable.updateSettings
                        colHeaders: columnHeaders
                    @instanceTable.render()
                    @setColHeadersSelection columnHeaders
                else
                    $log.error "TableService setColumnHeaders instanceTable is not defined"

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
