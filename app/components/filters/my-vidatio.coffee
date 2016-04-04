"use strict"

app = angular.module "app.filters"

app.filter "myVidatioFilter", [
    "$cookieStore"
    ($cookieStore) ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {Boolean} showOwnVidatios
        # @return {Array}
        return (input, showMyVidatios) ->
            return input if not showMyVidatios or not input

            globals = $cookieStore.get( "globals" ) or {}
            output = []

            if globals.currentUser?.id
                for element in input
                    if globals.currentUser.id is element.metaData.userId._id
                        output.push element

            output
]
