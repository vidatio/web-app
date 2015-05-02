# Animals E2E Test
# ================

describe "Protractor Demo", ->
    it "should have a title", ->
        browser.get "http://localhost:3123/"

        expect( browser.getTitle() ).toEqual "Animals WebApp"