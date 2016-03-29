"use strict"

app = angular.module("app.directives")

app.directive "select2", [
    "$translate"
    "$log"
    ($translate, $log) ->
        restrict: "EA"
        require: "ngModel"
        scope:
            model: "=ngModel"
            ajaxContent: "="
        template: "<input></input>"
        replace: true
        link: (scope, element) ->
            # @method initializeSelect2
            # @description initialize Select2 with the data being either data from the API or an empty array that
            #               Select2 is still working when the request fails. This method is called when the promise,
            #               which is passed to this directive via the ajaxContent isolate scope variable, is resolved
            #               or rejected
            # @param {Array} data
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

            # @description Reset selection of Select2 when newValue is falsy (i.e. State is changed without filters)
            scope.$watch( ->
                scope.model
            , (newValue, oldValue) ->
                angular.element(element).select2("val", "") if not newValue
            )
]
