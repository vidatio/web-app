exports.config =
    seleniumServerJar: "./node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar"
    chromeDriver: "./node_modules/protractor/selenium/chromedriver"
    capabilities:
        browserName: "chrome"
        name: "Vidatio Selenium"
    troubleshoot: true
    framework: "jasmine2"
    rootElement: "body"
    onPrepare: ->
        global.By = global.by
        browser.manage().window().maximize()
    jasmineNodeOpts:
        showColors: true
        defaultTimeoutInterval: 30000
        isVerbose: true
