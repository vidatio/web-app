"use strict"

class vidatio.BarChart extends vidatio.Visualization
    constructor: (dataset, options, width, height, chartSelector) ->
        vidatio.log.info "Barchart constructor called"
        vidatio.log.debug
            dataset: dataset
            options: options
            width: width
            height: height
            chartSelector: chartSelector

        super dataset, options.color, width, height, chartSelector
        @remove()
        @preProcess options

         # we need to wait for angular to finish rendering

        setTimeout =>



            # data = [
            #     {"year": 1991, "name": "alpha", "value": 15},
            #     {"year": 1991, "name": "beta", "value": 10},
            #     {"year": 1991, "name": "gamma", "value": 5},
            #     {"year": 1991, "name": "delta", "value": 50},
            #     {"year": 1992, "name": "alpha", "value": 20},
            #     {"year": 1992, "name": "beta", "value": 10},
            #     {"year": 1992, "name": "gamma", "value": 10},
            #     {"year": 1992, "name": "delta", "value": 43},
            #     {"year": 1993, "name": "alpha", "value": 30},
            #     {"year": 1993, "name": "beta", "value": 40},
            #     {"year": 1993, "name": "gamma", "value": 20},
            #     {"year": 1993, "name": "delta", "value": 17},
            #     {"year": 1994, "name": "alpha", "value": 60},
            #     {"year": 1994, "name": "beta", "value": 60},
            #     {"year": 1994, "name": "gamma", "value": 25},
            #     {"year": 1994, "name": "delta", "value": 32}
            # ]
            # d3plus.viz()
            # .container(@containerSelector)
            # .data(data)
            # .type("bar")
            # .id("name")
            # .x("year")
            # .y("value")
            # .draw()





            d3plus
            .viz()
            .container(@containerSelector)
            .format
                "text": (text, key) ->
                    key.locale.message = window.vidatio.d3PlusTranslations.message
                    key.locale.error = window.vidatio.d3PlusTranslations.error
                    return text
            .data(@chartData)
            .type("bar")
            .id("id")
            .text("x")
            .labels({
                text: "x"
            })
            .x(options.headers["x"])
            .y(options.headers["y"])
            .order("asc")
            .color("color")
            .width(@width)
            .height(@height)
            .draw()
        , 100


###
    @chartData = [
        {
            color: "#FA05AF"
            id: 0
            name: 200
            x: "Orange"
            y: 200
        },
        {
            color: "#FA05AF"
            id: 1
            name: 300
            x: "Banane"
            y: 300
        },
        {
            color: "#FA05AF"
            id: 2
            name: 400
            x: "Apfel"
            y: 400
        }
    ]

    options.headers = {x: "x", y: "y"}

    d3plus
    .viz()
    .container("#chart")
    .data(@chartData)
    .type("bar")
    .id("id")
    .text("name")
    .x(options.headers["x"])
    .y(options.headers["y"])
    .order("asc")
    .color("color")
    .width(500)
    .height(500)
    .draw()
###
