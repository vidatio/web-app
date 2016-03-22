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
        template: "<input></input>"
        replace: true
        link: (scope, element) ->
            scope.initializeSelect2 = (data) ->
                # when using $(element) the tests wouldn't run through
                # using angular.element fixes this issue
                angular.element(element).select2(
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
                scope.initializeSelect2(fetchedContent)
            , (reason) ->
                $log.error "Error while querying content for Select2"
                $log.debug
                    reason: reason

                scope.initializeSelect2([])
]
