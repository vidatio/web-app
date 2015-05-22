# File-Drop Directive
# ======================

app = angular.module "app.directives"

app.directive 'ngFileDrop', ->
    link: ($scope, el) ->

        el.bind 'drag', preventDefault
        el.bind 'dragstart', preventDefault
        el.bind 'dragend', preventDefault
        el.bind 'dragover', preventDefault
        el.bind 'dragenter', preventDefault
        el.bind 'dragleave', preventDefault
        el.bind 'drop', (e) ->
            preventDefault(e)
            $scope.file = e.dataTransfer.files[0]
            $scope.getFile()
            false


preventDefault = (e) ->
    e.preventDefault()
    false
