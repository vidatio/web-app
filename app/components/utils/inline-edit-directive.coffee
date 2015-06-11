# inline edit directive
# =====================

"use strict"

app = angular.module "app.directives"

app.directive "inlineEdit", ->
    restrict: "E"
    scope:
        formElement: "="

    template:
        """
            <div class="inline-edit clearfix">
                <span class="glyphicon glyphicon-pencil"
                    ng-show="formElement.disabled"></span>
                <span class="glyphicon glyphicon-ok"
                    ng-hide="formElement.disabled" ng-click="commit()"></span>
                <span class="glyphicon glyphicon-remove"
                    ng-hide="formElement.disabled" ng-click="reset()"></span>
            </div>
        """

    link: ( $scope, $element, $attrs ) ->

        rollbackCopy = undefined
        $scope.formElement.disabled = true
        inputElement = angular.element $element.parent().parent().find("input")

        $element.find( "span.glyphicon-pencil" ).bind "click", ->
            $scope.$apply( ->
                $scope.formElement.disabled = !$scope.formElement.disabled
            )

            inputElement[0].focus()
            rollbackCopy = angular.copy $scope.formElement
            $scope.$emit( "activeInput" )

        $scope.commit = ->
            if !$scope.formElement.$dirty
                $scope.reset()
                return

            if $scope.formElement.$dirty and $scope.formElement.$valid
                $scope.$emit( "inputCommit", $scope.formElement.$name )
                $scope.formElement.$setPristine()
                $scope.formElement.disabled = true

            else
                inputElement[0].focus()

        $scope.reset = ->
            $scope.formElement.$setPristine()
            $scope.formElement.disabled = true
            $scope.formElement.$setViewValue rollbackCopy.$viewValue
            $scope.formElement.$render()

        $scope.$parent.$on( "activeInput", (event) ->
            if event.targetScope isnt $scope and rollbackCopy isnt undefined
                $scope.reset()
        )


