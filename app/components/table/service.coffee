"use strict"

app = angular.module "app.services"

app.service 'TableService', [ ->

    class Table
        constructor: ->
            @dataset = [[]]

        setDataset: (data) ->
            # safely remove all items, keeps data binding alive
            @dataset.splice 0, @dataset.length

            rows = data.split('\n')

            i = 0
            while i < rows.length
                @dataset.push rows[i].split(',')
                ++i

    new Table
]
