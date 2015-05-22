# File Drop Directive Test
# =================

"use strict"

describe "testing component 'file-drop-directive'", ->
    scope = undefined
    compile = undefined
    element = undefined

    beforeEach ->
        module "app"
        inject ($rootScope, $controller, $compile) ->

            scope = $rootScope.$new()

            $controller 'FileReadCtrl', $scope: scope

            compile = $compile
            spyOn(scope, 'getFile').and.callFake()
            element = compile('<div id="drop-zone" ng-file-drop="onFileDrop($file)">Drop Files Here</div>')(scope)

            #spyOnEvent $(element), 'drop'

            $(element).on 'drop', ->
                scope.getFile()
                return false

    it 'and it should create a file reader', ->
        #$(element).trigger 'drop'
        #expect('drop').toHaveBeenTriggeredOn $(element)
        #expect(scope.getFile).toHaveBeenCalled()
