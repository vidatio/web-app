# Animals E2E Test
# ================

By.addLocator "uisref", (toState, opt_parentElement) ->
    using = opt_parentElement or document
    prefixes = [ "ui-sref" ]
    p = 0
    while p < prefixes.length
        selector = "*[" + prefixes[p] + "='" + toState + "']"
        inputs = using.querySelectorAll(selector)
        return inputs if inputs.length
        ++p
    return

###
By.addLocator "link", (href, parentElement) ->
    parentElement = parentElement or document
    links = parentElement.querySelectorAll "a"
    links.filter ( link ) ->
        console.log link.href
        link.href and (link.href == href or link.href == link.baseURI + href)
###

EC = protractor.ExpectedConditions



describe "Protractor Demo", ->
    it "should have a title", ->
        browser.get "http://localhost:3123/"

        expect( browser.getTitle() ).toEqual "Animals WebApp"

    it "should fail with wrong credentials", ->
        browser.get "http://localhost:3123/"

        element( By.model("loginData.name") ).sendKeys "adsf"
        element( By.model("loginData.password") ).sendKeys "asdf"

        element( By.css(".login-button") ).click()

        expect( element( By.binding("alert.message") ).getText() ).toEqual "Name/Password invalid."



    it "should pass with correct credentials", ->
        browser.get "http://localhost:3123/"

        element( By.model("loginData.name") ).sendKeys "admin"
        element( By.model("loginData.password") ).sendKeys "admin"

        element( By.css(".login-button") ).click()

        expect( element( By.tagName("h1") ).getText() ).toEqual "Penguins"
