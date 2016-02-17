"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset) ->
        vidatio.log.info "Barchart constructor called"

        setTimeout( =>
            @chart = c3.generate
                bindto: "#chart"
                data:
                    columns: dataset,
                    type: "bar"
                bar: width: ratio: 0.5
                padding:
                    right: 30

            super(dataset, @chart)
        , 500)

    updateDataset: (dataset) ->
        vidatio.log.info "Barchart updateDataset called"
        vidatio.log.debug
            dataset: dataset

        @chart.load
            columns: dataset
