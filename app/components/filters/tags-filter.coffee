"use strict"

app = angular.module "app.filters"

app.filter "tagsFilter", [
    "$log"
    ($log) ->
        return (input, tags) ->
            $log.info "TagsFilter called"
            $log.debug
                tags: tags


]
