exports.config =
    seleniumServerJar: "/home/ubuser/.nvm/versions/node/v0.12.2/lib/node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar"
    chromeDriver: "/home/ubuser/.nvm/versions/node/v0.12.2/lib/node_modules/protractor/selenium/chromedriver"
    capabilities:
        browserName: 'chrome'

    jasmineNodeOpts:
        showColors: true
        defaultTimeoutInterval: 30000