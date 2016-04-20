"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    "DataService"
    "MapService"
    "ConverterService"
    "$log"
    "VisualizationService"
    "$timeout"
    ($scope, Table, Data, Map, Converter, $log, Visualization, $timeout) ->
        $scope.dataset = Table.dataset
        $scope.data = Data
        $scope.visualization = Visualization.options
        $scope.offset = 0
        $scope.extraOffset = 0
        # attention: one way data binding
        $scope.useColumnHeadersFromDataset = Table.useColumnHeadersFromDataset

        headerCheckbox = $('#column-headers-checkbox')
        if headerCheckbox?.radiocheck? then headerCheckbox.radiocheck()

        $scope.toggleHeader = ->
            clearFocusedAxisButtons()

            if $scope.data.metaData.fileType isnt "shp"
                if $scope.useColumnHeadersFromDataset
                    Table.takeHeaderFromDataset()
                else
                    Table.putHeaderToDataset()

            Visualization.create()

        #@method $scope.transpose
        #@description transpose the dataset including the header
        $scope.transpose = ->
            clearFocusedAxisButtons()

            if $scope.useColumnHeadersFromDataset then Table.putHeaderToDataset()
            Table.setDataset vidatio.helper.transposeDataset Table.getDataset()
            if $scope.useColumnHeadersFromDataset then Table.takeHeaderFromDataset()

            Visualization.create()

        #@method $scope.download
        #@description downloads a csv
        $scope.download = ->
            clearFocusedAxisButtons()
            Data.downloadCSV($scope.data.name)

        headerLength = 0

        # https://github.com/kapetan/jquery-observe
        $timeout ->
            $header = $(".ht_clone_top th")

            headerLength = $header.length
            headerLengthInit = $header.length

            $('.ht_clone_top table thead > tr').observe 'childlist', 'th', (record) ->
                $header = $(".ht_clone_top th")

                console.log "\n\n ---------"

                console.log "headerLengthInit", headerLengthInit
                console.log "headerLength", headerLength
                console.log "$header.length", $header.length
                console.log record


                offset = Math.abs(headerLength - $header.length)

                if headerLength - $header.length > 0
                    offset = offset * -1

                console.log "offset", offset
                console.log "$scope.offset", $scope.offset
                $scope.offset += offset
                console.log "$scope.offset", $scope.offset

                $scope.extraOffset = -Math.max(Math.abs(headerLength - headerLengthInit), Math.abs($header.length - headerLengthInit)) + 1

                console.log "$scope.extraOffset", $scope.extraOffset

                Table.updateAxisSelection $scope.visualization.xColumn + $scope.offset + $scope.extraOffset, $scope.visualization.yColumn + $scope.offset + $scope.extraOffset

                headerLength = $header.length



        #@method $scope.axisSelection
        #@description selects axis by clicking on the header and creates new visualization
        $scope.axisSelection = (axis) ->
            $header = $(".ht_clone_top th")
            $header.removeClass "selected"
            $header.unbind "click"

            if axis is "x"
                if $(".x-axis-button").hasClass "focused"
                    $(".x-axis-button").removeClass "focused"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.xColumn) + $scope.offset + 1
                $(".y-axis-button").removeClass "focused"
                $(".x-axis-button").addClass "focused"
            else
                if $(".y-axis-button").hasClass "focused"
                    $(".y-axis-button").removeClass "focused"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.yColumn) + $scope.offset + 1
                $(".x-axis-button").removeClass "focused"
                $(".y-axis-button").addClass "focused"

            $header.addClass "highlighted"

            $header.each (idx, element) ->
                if idx is currentColumn
                    $(element).addClass "selected"

                $(element).click (event) ->
                    if not $(element).find("span").hasClass "selected-x-y"
                        $header.find("span").removeClass "selected-x-y"

                        if axis is "x"
                            $scope.visualization.xColumn = $(element).context.cellIndex - $scope.offset - $scope.extraOffset
                            console.log "$(element).context.cellIndex", $(element).context.cellIndex
                            console.log "$scope.offset", $scope.offset
                            console.log "$scope.extraOffset", $scope.extraOffset
                            console.log "X", $scope.visualization.xColumn
                            $header.find("span").removeClass "selected-x"
                            $(element).find("span").addClass "selected-x"

                            if $(element).find("span").hasClass "selected-y"
                                $(element).find("span").addClass "selected-x-y"

                        else
                            $scope.visualization.yColumn = $(element).context.cellIndex - $scope.offset - $scope.extraOffset
                            console.log "$(element).context.cellIndex", $(element).context.cellIndex
                            console.log "$scope.offset", $scope.offset
                            console.log "$scope.extraOffset", $scope.extraOffset
                            console.log "Y", $scope.visualization.yColumn
                            $header.find("span").removeClass "selected-y"
                            $(element).find("span").addClass "selected-y"

                            if $(element).find("span").hasClass "selected-x"
                                $(element).find("span").addClass "selected-x-y"

                        Visualization.create()

                    clearFocusedAxisButtons()
                    $header.removeClass "highlighted"
                    $header.removeClass "selected"
                    $header.unbind "click"

            return true

        # remove focus-states from axis-buttons if other icons are clicked
        clearFocusedAxisButtons = ->
            $("[class*='-axis-button']").removeClass "focused"

]
