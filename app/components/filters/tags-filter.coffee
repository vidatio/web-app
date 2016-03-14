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
            $log.info "TagsFilter called"
            $log.debug
                tags: tags

            return input if not tags?.length or not input

            output = []

            for element in input
                preprocessedTags = preprocessTagsFilter(element.metaData?.tags).split(", ")
                for tag in tags
                    idx = preprocessedTags.join("|").toLowerCase().split("|").indexOf tag.toLowerCase()
                    if idx >= 0
                        output.push element
                        break

            return output
]
