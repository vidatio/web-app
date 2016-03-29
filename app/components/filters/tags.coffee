"use strict"

app = angular.module "app.filters"

app.filter "tagsFilter", [
    "$log"
    "preprocessTagsFilter"
    ($log, preprocessTagsFilter) ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {Array} tags
        # @return {Array}
        return (input, tags) ->
            return input if not tags?.length or not input

            output = []

            for element in input
                preprocessedTags = preprocessTagsFilter(element.metaData?.tagIds).split(", ")
                for tag in tags
                    if tag.toLowerCase() in vidatio.helper.arrayToLowerCase(preprocessedTags)
                        output.push element
                        break

            return output
]
