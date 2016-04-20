"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "$log"
    ($log) ->
        class Table
            constructor: ->
                @dataset = [[]]
                @header = []
                @useColumnHeadersFromDataset = true
                @instanceTable = null
                @diagramColumns = {}
                @minColumns = 26
                @minRows = 26

            # @method setInstance
            # @public
            # @param {Handsontable Instance} hot
            setInstance: (hot) ->
                @instanceTable = hot

            # @method getInstance
            # @public
            # @return {Handsontable Instance}
            getInstance: ->
                return @instanceTable

            # @method getHeader
            # @public
            getHeader: ->
                return @header

            # @method setHeader
            # @public
            # @param {Array} header
            # @param {String} fileType
            setHeader: (header = []) ->
                setHeader.call @, header

                # regex is used to set default headers if the header array has only null values
                isHeaderEmpty = @header.join().replace(/,/g,'').length

                if @useColumnHeadersFromDataset and isHeaderEmpty isnt 0
                    colHeaders = @header
                else
                    colHeaders = true

                # because we access the table service before the editor and so the directive is loaded
                unless @instanceTable
                    return $log.warn "TableService resetHeader instanceTable is not defined"

                @instanceTable.updateSettings
                    colHeaders: colHeaders
                @instanceTable.render()

                if colHeaders is true and isHeaderEmpty isnt 0
                    setHeader.call @, @instanceTable.getColHeader()

            setHeader = (header) ->
                tmp = angular.copy(header)
                @header.splice 0, @header.length
                tmp.forEach (cell, index) =>
                    @header[index] = cell

            # @method setColumns
            # @public
            setColumns: ->
                columns = @getColumns()

                unless @instanceTable
                    return $log.warn "TableService setColumns instanceTable is not defined"

                @instanceTable.updateSettings
                    columns: columns

            # @method getColumns
            # @public
            # @return {Array}
            getColumns: ->
                columns = []

                @header.forEach (element, index) ->
                    if element is "type" or element.indexOf("bbox") > -1 or element is null
                        columns.push
                            readOnly: true
                    else
                        columns.push {}

                return columns

            # @method takeHeaderFromDataset
            # @public
            takeHeaderFromDataset: ->
                header = @dataset.shift()
                @useColumnHeadersFromDataset = true
                @setHeader header

            # @method putHeaderToDataset
            # @public
            putHeaderToDataset: ->
                @useColumnHeadersFromDataset = false
                @dataset.unshift angular.copy(@header)
                @setHeader()

            # @method setDataset
            # @public
            # @param {Array} data
            setDataset: (dataset = []) ->
                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

                dataset.forEach (row, index) =>
                    @dataset[index] = row

            # @method getDataset
            # @public
            # @return {Array}
            getDataset: ->
                return @dataset

            # @method updateAxisSelection
            # @description updates "X" and "Y" on table header
            # @public
            # @param {Number} xColumn
            # @param {Number} yColumn
            updateAxisSelection: (xColumn, yColumn) ->
                $log.info "TableService updateAxisSelection called"
                $log.debug
                    xColumn: xColumn
                    yColumn: yColumn

                $header = $(".ht_clone_top th")

                $header.find("span").removeClass "selected-x-y"
                $header.find("span").removeClass "selected-x"
                $header.find("span").removeClass "selected-y"

                $header.each (idx, element) ->
                    if idx is xColumn and idx is yColumn
                        $(element).find("span").addClass "selected-x-y"
                    else if idx is xColumn
                        $(element).find("span").addClass "selected-x"
                    else if idx is yColumn
                        $(element).find("span").addClass "selected-y"

            # @method hasData
            # @description checks if the dataset has data
            # @public
            # @return {Boolean}
            hasData: ->
                hasData = false
                @dataset.forEach (row, rowIndex) ->
                    row.forEach (element, index) ->
                        if element?
                            hasData = true
                return hasData


        new Table
]
