###
DESCRIPTION
User should be allowed to drop a file everywhere, so the file drop directive is split into two parts.
Into the directive on which element it should start draggingZ and the directive on which element it should end
###

app = angular.module "app.directives"

app.directive 'ngFileDropStart', ->
    link: ($scope, el) ->

#over: cursor currently moves over the drop-zone
        el.bind "dragover", (e) ->
            e.preventDefault()
            false

        #enter: cursor enters the drop-zone
        el.bind "dragenter", (e) ->
            document.getElementById("drop-zone").style.display = "block"
            e.preventDefault()
            false

