"use strict"

app = angular.module("app.directives")

app.directive "select2", [
    "$rootScope"
    "TagsFactory"
    ($rootScope, TagsFactory) ->
        restrict: "EA"
        require: "ngModel"
        link: (scope, element, attrs, ngModel) ->
            TagsFactory.query (response) ->
                tagsData = []
                for item, index in response
                    tagsData.push
                        id: item.name
                        text: item.name
                $(element).select2(
                    tags: true
                    tokenSeparators: [","]
                    data: tagsData
                    createSearchChoice: (term) ->
                        return {
                            id: term
                            text: term
                        }
                )
]
