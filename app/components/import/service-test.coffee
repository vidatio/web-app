# File Reader Service Test
# =================

"use strict"

# what to test:
#   - does not return undefined
#   - event fired (if not too complex)
#   - content of file?

describe "Service Import", ->
    beforeEach ->
        module "app"
        inject (ImportService, $rootScope, $q) ->
            @scope = $rootScope.$new()
            @deferred = $q.defer()
            @Import = ImportService

    xdescribe "on reading file", ->
        it 'should should return a promise', ->
            expect(@Import.readFile()).toBeDefined()
