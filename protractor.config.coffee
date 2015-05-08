exports.config =
    seleniumServerJar: "./node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar"
    chromeDriver: "./node_modules/protractor/selenium/chromedriver"
    multiCapabilities: [
        { browserName: "chrome" }
        { browserName: "firefox" }
    ]
    onPrepare: ->
        global.By = global.by
        browser.manage().window().setSize 1600, 1000
    jasmineNodeOpts:
        showColors: true
        defaultTimeoutInterval: 30000
