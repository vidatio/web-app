# File Reader Factory Test
# =================

"use strict"

describe "testing component 'file-reader-factory'", ->
    scope = undefined
    rootScope = undefined
    file = undefined

    beforeEach ->
        module "app"
        inject ($rootScope, $controller, $compile, $q, FileReader) ->

            scope = $rootScope.$new()
