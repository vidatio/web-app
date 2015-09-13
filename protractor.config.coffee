exports.config =
    seleniumServerJar: "./node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar"
    chromeDriver: "./node_modules/protractor/selenium/chromedriver"
    multiCapabilities: [
        { browserName: "chrome" }
        # Firefox version > 37 not compatible with selenium at the moment
        # see https://stackoverflow.com/questions/31322951/why-does-firefox-error-message-pop-up-when-running-protractor-test
        # { browserName: "firefox" }
    ]
    onPrepare: ->
        global.By = global.by
        browser.manage().window().setSize 1600, 1000
    jasmineNodeOpts:
        showColors: true
        defaultTimeoutInterval: 30000
