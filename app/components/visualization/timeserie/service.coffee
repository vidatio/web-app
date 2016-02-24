"use strict"

class vidatio.TimeseriesChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Timeseries chart constructor called"
        vidatio.log.debug
            dataset: dataset

        # handle different date formats and parse them for c3.js charts
        for date, index in dataset[0]
            if index != 0
                tmp = moment(date, ["MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD"]).format("YYYY-MM-DD")
                dataset[0][index] = tmp


        sample_data = [
            {
                'year': 1991
                'name': 'alpha'
                'value': 17
            }
            {
                'year': 1992
                'name': 'alpha'
                'value': 20
            }
            {
                'year': 1993
                'name': 'alpha'
                'value': 25
            }
            {
                'year': 1994
                'name': 'alpha'
                'value': 33
            }
            {
                'year': 1995
                'name': 'alpha'
                'value': 52
            }
            {
                'year': 1991
                'name': 'beta'
                'value': 36
            }
            {
                'year': 1992
                'name': 'beta'
                'value': 32
            }
            {
                'year': 1993
                'name': 'beta'
                'value': 40
            }
            {
                'year': 1994
                'name': 'beta'
                'value': 58
            }
            {
                'year': 1995
                'name': 'beta'
                'value': 13
            }
            {
                'year': 1991
                'name': 'gamma'
                'value': 24
            }
            {
                'year': 1992
                'name': 'gamma'
                'value': 27
            }
            {
                'year': 1994
                'name': 'gamma'
                'value': 35
            }
            {
                'year': 1995
                'name': 'gamma'
                'value': 40
            }
        ]

        setTimeout(->
            vidatio.log.info "Timeseries chart generation called"

            chart = d3plus.viz()
                .container("#chart")
                .data(sample_data)
                .type("line")
                .id("name")
                .text("name")
                .y("value")
                .x("year")
                .draw()

            super(dataset, chart)
        , 500)
