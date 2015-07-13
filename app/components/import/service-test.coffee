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
        inject (ImportService, $rootScope, $q, $injector) ->
            @injector = $injector
            @scope = $rootScope.$new()
            @deferred = $q.defer()
            @Import = ImportService

    it 'should be defined and included', ->
        expect(@Import).toBeDefined()
        expect(@injector.has("ImportService"))

    it 'should return a promise on readFile', ->
        expect(@Import.readFile()).toBeDefined()

    it 'should have a FileReader object', ->
        expect(@Import.reader).toBeDefined()
        expect(@Import.reader instanceof FileReader).toBeTruthy()
