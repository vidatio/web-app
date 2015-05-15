# File-Select Directory
# ======================

app = angular.module "upload.directives"

app.directive 'ngFileSelect', ->
    link: ($scope, el) ->
        el.bind 'change', (e) ->
            $scope.file = (e.srcElement or e.target).files[0]
            $scope.getFile()
