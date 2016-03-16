"use strict"

app = angular.module "app.filters"

app.filter "myVidatioFilter", [
    "$log"
    "$cookieStore"
    ($log, $cookieStore) ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {Boolean} showOwnVidatios
        # @return {Array}
        return (input, showMyVidatios) ->
            $log.info "myVidatioFilter called"
            $log.debug
                showMyVidatios: showMyVidatios

            return input if not showMyVidatios or not input

            globals = $cookieStore.get( "globals" ) or {}
            output = []

            if globals.currentUser?.id
                for element in input
                    if globals.currentUser.id is element.userId._id
                        output.push element

            output
]
