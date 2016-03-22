"use strict"

app = angular.module("app.services")

app.service "TagsService", [
    "$q"
    "$log"
    "TagsFactory"
    ($q, $log, TagsFactory) ->
        class Tags
            getAndPreprocessTags: ->
                query = TagsFactory.query().$promise

                promise = query.then (response) ->
                    tagsData = []
                    for item, index in response
                        tagsData.push
                            id: item.name
                            text: item.name

                    tagsData

                promise

        new Tags
]

