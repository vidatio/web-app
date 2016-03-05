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
                @diagramColumns = {}

            # @method initAxisSelection
            # @public
            initAxisSelection: ->
                $log.info "TableService initAxisSelection called"

                colHeaders = @instanceTable.getColHeader()
                $log.debug
                    colHeaders: colHeaders

                @setColHeadersSelection colHeaders

            # @method setColHeadersSelection
            # @public
            # @param {Array} colHeaders
            setColHeadersSelection: (colHeaders) ->
                $log.info "TableService setColHeaderSelection called"
                $log.debug
                    colHeaders: colHeaders

                @colHeadersSelection.splice 0, @colHeadersSelection.length
                colHeaders.forEach (item, index) =>
                    if item is null
                        return
                    @colHeadersSelection[index] = item

            # @method setInstance
            # @public
            # @param {Handsontable Instance} hot
            setInstance: (hot) ->
                $log.info "TableService setInstance called"
                @instanceTable = hot

            # @method getInstance
            # @public
            # @return {Handsontable Instance}
            getInstance: ->
                $log.info "TableService getInstance called"
                return @instanceTable

            getColumnHeaders: ->
                $log.info "TableService getColumnHeaders called"

                if @instanceTable
                    return @instanceTable.getColHeader().filter( (value) ->
                        return value if value?
                    )
                else
                    []

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

                @useColumnHeadersFromDataset = false

                if @instanceTable
                    @instanceTable.updateSettings
                        colHeaders: true
                    @instanceTable.render()
                    @setColHeadersSelection @instanceTable.getColHeader()
                else
                    $log.warn "TableService resetColumnHeaders instanceTable is not defined"

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

            # @method resetDataset
            # @public
            resetDataset: ->
                $log.info "TableService resetDataset called"

                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            # @method setDataset
            # @public
            # @param {Array} data
            setDataset: (data) ->
                $log.info "TableService setDataset called"
                $log.debug
                    message: "TableService setDataset called"
                    data: data

                @reset true
                data.forEach (row, index) =>
                    @dataset[index] = row

            # @method getDataset
            # @public
            # @return {Array}
            getDataset: ->
                $log.info "TableService getDataset called"

                return @dataset

            # @method setDiagramColumns
            # @public
            setDiagramColumns: (xColumn, yColumn) ->
                $log.info "TableService setDiagramColumns called"
                $log.debug
                    xColumn: xColumn
                    yColumn: yColumn

                unless xColumn or yColumn
                    return

                @diagramColumns["x"] = xColumn
                @diagramColumns["y"] = yColumn

            # @method getDiagramColumns
            # @public
            # @return {Object}
            getDiagramColumns: ->
                $log.info "TableService getDiagramColumns called"
                @diagramColumns

        new Table
]
