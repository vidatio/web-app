exports.config =
    seleniumServerJar: "./node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar"
    chromeDriver: "./node_modules/protractor/selenium/chromedriver"
    capabilities:
        browserName: "chrome"

    jasmineNodeOpts:
        showColors: true
        defaultTimeoutInterval: 30000
