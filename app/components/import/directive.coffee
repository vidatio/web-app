# File Reader Directive
#
# User should be allowed to drop a file everywhere, so the file drop directive is split into two parts.
# Into the directive on which element it should start dragging and the directive on which element it should end
#
# =================

"use strict"
app = angular.module "app.directives"

app.directive 'ngFileDropStart', [
    "$log"
    ($log) ->
        link: ($scope, el) ->

            #over: cursor currently moves over the drop-zone
            el.bind "dragover", (e) ->
                e.preventDefault()
                false

            #enter: cursor enters the drop-zone
            el.bind "dragenter", (e) ->
                $log.info "ngFileDropStart dragenter called"

                document.getElementById("drop-zone").style.display = "block"
                e.preventDefault()
                false
]

app.directive 'ngFileDropEnd', [
    "$log"
    ($log) ->
        link: ($scope, el) ->

            #leave: cursor moves out of drop-zone
            el.bind "dragleave", (e) ->
                $log.info "ngFileDropEnd dragleave called"

                document.getElementById("drop-zone").style.display = "none"
                e.preventDefault()
                false

            #over: cursor currently moves over the drop-zone
            el.bind "dragover", (e) ->
                e.preventDefault()
                false

            #drop: file got dropped on the drop-zone
            el.bind "drop", (e) ->
                $log.info "ngFileDropEnd drop called"

                e.preventDefault()
                document.getElementById("drop-zone").style.display = "none"
                $scope.file = e.originalEvent.dataTransfer.files[0]
                $scope.getFile("dragged")
                false
]

app.directive 'ngFileSelect', [
    "$log"
    ($log) ->
        link: ($scope, el) ->
            el.bind "change", (e) ->
                $log.info "ngFileSelect change called"

                $scope.file = (e.srcElement or e.target).files[0]
                $scope.getFile()
]
