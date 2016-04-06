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

            # @method setInstance
            # @public
            # @param {Handsontable Instance} hot
            setInstance: (hot) ->
                #$log.info "TableService setInstance called"
                @instanceTable = hot

            # @method getInstance
            # @public
            # @return {Handsontable Instance}
            getInstance: ->
                #$log.info "TableService getInstance called"
                return @instanceTable

            # @method getHeader
            # @public
            getHeader: ->
                #$log.info "TableService getHeader called"
                return @header

            # @method setHeader
            # @public
            # @param {Array} header
            # @param {String} fileType
            setHeader: (header = []) ->
                #$log.info "TableService setHeader called"
                #$log.debug
                #    header: header

                setHeader.call @, header

                if @useColumnHeadersFromDataset
                    colHeaders = @header
                else
                    colHeaders = true

                unless @instanceTable
                    return $log.info "TableService resetHeader instanceTable is not defined"

                @instanceTable.updateSettings
                    colHeaders: colHeaders
                @instanceTable.render()

                if colHeaders is true then setHeader.call @, @instanceTable.getColHeader()

            setHeader = (header) ->
                tmp = angular.copy(header)
                @header.splice 0, @header.length
                tmp.forEach (cell, index) =>
                    @header[index] = cell

            # @method takeHeaderFromDataset
            # @public
            takeHeaderFromDataset: ->
                #$log.info "TableService takeHeaderFromDataset called"
                header = @dataset.shift()
                @useColumnHeadersFromDataset = true
                @setHeader header

            # @method putHeaderToDataset
            # @public
            putHeaderToDataset: ->
                #$log.info "TableService putHeaderToDataset called"
                @useColumnHeadersFromDataset = false
                @dataset.unshift angular.copy(@header)
                @setHeader()

            # @method setDataset
            # @public
            # @param {Array} data
            setDataset: (dataset = []) ->
                #$log.info "TableService setDataset called"
                #$log.debug
                #    data: dataset

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
                #$log.info "TableService getDataset called"
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


        new Table
]
