"use strict"

describe "Visualization Ctrl", ->
    beforeEach ->
        module "app"

        inject ($controller, $rootScope, TableService) ->
            @scope = $rootScope.$new()
            @TableService = TableService
            TableCtrl = $controller "TableCtrl", $scope: @scope, TableService: @TableService

    describe "on calling the scope transpose function", ->
        it 'should tranpose the dataset including the header correct', ->
            @TableService.setDataset [
                [
                    0
                    1
                ]
                [
                    2
                    3
                ]
            ]
            @scope.useColumnHeadersFromDataset = false
            @scope.transpose()
            expect(@TableService.getDataset()).toEqual [
                [
                    0
                    2
                ]
                [
                    1
                    3
                ]
            ]

            @scope.useColumnHeadersFromDataset = true
            @TableService.setDataset [
                [
                    2
                    3
                ]
            ]
            @TableService.setHeader [
                0
                1
            ]

            @scope.transpose()
            expect(@TableService.getDataset()).toEqual [
                [
                    1
                    3
                ]
            ]

            expect(@TableService.getHeader()).toEqual [
                0
                2
            ]



