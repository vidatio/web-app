"use strict"

app = angular.module "app.services"

app.service 'ScatterPlotService', [
    "$log"
    "$timeout"
    ($log, $timeout) ->
        class ScatterPlot
            constructor: (@dataset) ->
                $log.info "ScatterPlotService constructor called"

                $timeout =>
                    @chart = c3.generate
                        bindto: "#chart"
                        data:
                            xs:
                                "setosa": 'setosa_x'
                                "versicolor": 'versicolor_x'
                            columns: @dataset,
                            type: 'scatter'
                        padding:
                            right: 30

            getChart: ->
                return @chart

]
