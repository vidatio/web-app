EC = protractor.ExpectedConditions


describe "The language", ->

    it "should be german with german URL", ->
        browser.get "/de/"
        expect( element( By.id("slogan") ).getText() ).toEqual "Echte Ergebnisse in Echtzeit!"

    it "should be preserved when a link is clicked", ->
        browser.get "/de/"

        element( By.css(".get-started a") ).click()
        expect( browser.getCurrentUrl() ).toEqual "http://localhost:3123/de/import"

        element( By.id("option-empty-table") ).click()
        expect( browser.getCurrentUrl() ).toEqual "http://localhost:3123/de/editor"

    it "should have the correct translations when a link is clicked", ->
        browser.get "/de/"

        element( By.css(".get-started a") ).click()
        expect( element( By.css("#option-empty-table a h3") ).getText() ).toEqual "LEERE TABELLE"
