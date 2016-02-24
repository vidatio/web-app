"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Barchart constructor called"

        console.log "DATASET", dataset

        data = [
            {
                'year': 1991
                'name': 'alpha'
                'value': 15
            }
            {
                'year': 1991
                'name': 'beta'
                'value': 10
            }
            {
                'year': 1991
                'name': 'gamma'
                'value': 5
            }
            {
                'year': 1991
                'name': 'delta'
                'value': 50
            }
            {
                'year': 1992
                'name': 'alpha'
                'value': 20
            }
            {
                'year': 1992
                'name': 'beta'
                'value': 10
            }
            {
                'year': 1992
                'name': 'gamma'
                'value': 10
            }
            {
                'year': 1992
                'name': 'delta'
                'value': 43
            }
            {
                'year': 1993
                'name': 'alpha'
                'value': 30
            }
            {
                'year': 1993
                'name': 'beta'
                'value': 40
            }
            {
                'year': 1993
                'name': 'gamma'
                'value': 20
            }
            {
                'year': 1993
                'name': 'delta'
                'value': 17
            }
            {
                'year': 1994
                'name': 'alpha'
                'value': 60
            }
            {
                'year': 1994
                'name': 'beta'
                'value': 60
            }
            {
                'year': 1994
                'name': 'gamma'
                'value': 25
            }
            {
                'year': 1994
                'name': 'delta'
                'value': 32
            }
        ]

        setTimeout( ->
            chart = d3plus.viz().container("#chart").data(data).type("bar").id("name").x("year").y("value").draw()

            super(dataset, chart)
        , 500)
