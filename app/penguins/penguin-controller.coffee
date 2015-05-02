# Penguins Controller
# ===================

"use strict"

app = angular.module "animals.controllers"

app.controller "PenguinCtrl", [
    "$scope"
    "PenguinService"
    "$stateParams"
    "$state"
    ($scope, PenguinService, $stateParams, $state) ->

        if $stateParams.penguin?
            $scope.penguin = PenguinService.penguin
            $scope.delete = ->
                PenguinService.delete( $scope.penguin._id ).then ->
                    $state.go "penguins"

        else if $state.current.name is "penguins.new"
            $scope.penguins = PenguinService.penguins

        else
            $scope.penguins = PenguinService.penguins

            $scope.$on "$stateChangeStart", (e, target) ->
                if target.name is "penguins.new"
                    $scope.isNewPenguin = true
                else
                    $scope.isNewPenguin = false

        $scope.create = ->
            PenguinService.create( $scope.newPenguin ).then(
                (penguin) ->
                    $state.go( "penguins.detail",
                        { penguin: penguin._id }
                        { reload: true }
                    )
                , (error) ->
                    console.log "penguin controller new penguin error", error
            )
]
