# File Select Directive Test
# =================

"use strict"

describe "testing component 'file-select-directive'", ->
    scope = undefined
    compile = undefined

    beforeEach ->
        module "app"
        inject ($rootScope, $controller, $compile) ->

            scope = $rootScope.$new()

            $controller 'FileReadCtrl', $scope: scope

            compile = $compile
            spyOn(scope, 'getFile').and.callFake()

    it 'should create file reader', ->
        elm = compile('<input type="file" ng-file-select="onFileSelect($files)">')(scope)
        # elm[0].dispatchEvent new CustomEvent('change')
        # expect(scope.getFile).toHaveBeenCalled()
