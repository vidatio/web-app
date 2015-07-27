"use strict"
app = angular.module "app.directives"

app.directive 'hot', ($timeout, TableService) ->
    restriction: "EA"
    template: '<div id="datatable"></div>'
    replace: true
    scope:
        dataset: '='
        activeViews: '='
    link: ($scope, $element) ->
        hot = new Handsontable($element[0],
            data: $scope.dataset
            minCols: 26
            minRows: 26
            rowHeaders: true
            colHeaders: true
            currentColClassName: 'current-col'
            currentRowClassName: 'current-row'
            afterChange: (change, source) ->
                if(source == "edit")
                    TableService.setCell(change[0][0], change[0][1], change[0][3])
        )


