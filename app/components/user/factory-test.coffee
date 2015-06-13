# User Factory Test
# =================

"use strict"

describe "testing component 'UserFactory'", ->

    UserFactory = undefined

    beforeEach ->
        module "app"
        inject (_UserFactory_) ->
            UserFactory = _UserFactory_

    it "should be available", ->
        expect( UserFactory ).toBeDefined()
