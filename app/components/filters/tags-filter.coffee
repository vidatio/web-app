"use strict"

app = angular.module "app.filters"

app.filter "tagsFilter", [
    "$log"
    ($log) ->
        return (input, tags) ->
            $log.info "TagsFilter called"
            $log.debug
                tags: tags

            return input if not tags?.length or not input

            output = []

            for element in input
                for tag in tags
                    idx = element.metaData?.tags?.indexOf tag
                    if idx >= 0
                        output.push element
                        break

            return output
]
