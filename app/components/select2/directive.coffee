"use strict"

app = angular.module("app.directives")

app.directive "select2", [
    "$translate"
    "$log"
    ($translate, $log) ->
        restrict: "EA"
        require: "ngModel"
        scope:
            ajaxContent: "="
        link: (scope, element) ->
            initializeSelect2 = (data) ->
                $(element).select2(
                    tags: true
                    tokenSeparators: [","]
                    data: data
                    createSearchChoice: (term) ->
                        return {
                            id: term
                            text: term
                        }
                    formatNoMatches: ->
                        $translate.instant("SELECT2.NO_MATCHING_RESULTS")
                )


            scope.ajaxContent.then (fetchedContent) ->
                initializeSelect2(fetchedContent)
            , (reason) ->
                $log.error "Error while querying content for Select2"
                $log.debug
                    reason: reason

                initializeSelect2([])
]
