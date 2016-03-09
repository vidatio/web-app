"use strict"

app = angular.module "app.filters"

app.filter "myVidatioFilter", [
    "$log"
    ($log) ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {String} category
        # @return {Array}
        return (input, showOwnVidatios) ->
            $log.info "myVidatioFilter called"
            $log.debug
                showOwnVidatios: showOwnVidatios

            return input if not showOwnVidatios or not input

            output = []

            # for element in input


            # output
]
