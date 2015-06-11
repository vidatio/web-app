# File-Select Directive
# ======================

app = angular.module "app.directives"

app.directive 'ngFileSelect', ->
    link: ($scope, el) ->
        el.bind 'change', (e) ->
            $scope.file = (e.srcElement or e.target).files[0]
            $scope.getFile()
