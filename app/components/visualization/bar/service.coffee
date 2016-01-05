"use strict"

app = angular.module "app.services"

app.service "BarChartService", [
    "$log"
    "$timeout"
    ($log, $timeout) ->
        class BarChart
            constructor: (@dataset) ->
                $log.info "BarChartService constructor called"


                ###
                columns: [
                    ["data1", 30, 200, 100, 400, 150, 250]
                    ["data2", 130, 100, 140, 200, 150, 50]
                ]
                ###

                $timeout =>
                    @chart = c3.generate
                        bindto: "#chart"
                        data:
                            columns: @dataset,
                            type: "bar"
                        bar: width: ratio: 0.5
                        padding:
                            right: 30

            getChart: ->
                return @chart
]
