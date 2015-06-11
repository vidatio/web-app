module.exports = (config) ->
    config.set

        # base path that will be used to resolve all patterns (eg. files, exclude)
        basePath: ""


        # frameworks to use
        # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ["jasmine-jquery", "jasmine"]


        # list of files / patterns to load in the browser
        files: [

            # third party libs
            "./bower_components/jquery/dist/jquery.js"
            "./bower_components/angular/angular.js"
            "./bower_components/angular-route/angular-route.js"
            "./bower_components/angular-resource/angular-resource.js"
            "./bower_components/angular-animate/angular-animate.js"
            "./bower_components/angular-cookies/angular-cookies.js"
            "./bower_components/angular-bootstrap/ui-bootstrap-tpls.js"
            "./bower_components/ng-file-upload/angular-file-upload.js"
            "./bower_components/angular-mocks/angular-mocks.js"
            "./bower_components/angular-ui-router/release/angular-ui-router.js"
            "./bower_components/bootstrap/dist/js/bootstrap.js"

            # source files
            "./app/init-deps.coffee"
            "./app/app.coffee"
            "./app/app-controller.coffee"
            "./app/*/**/*.coffee"

            #test files
            "./app/**/*_test.coffee"
        ]


        # list of files to exclude
        exclude: [
        ]


        # preprocess matching files before serving them to the browser
        # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors: {
            "**/*.coffee": ["coffee"]
        }


        # test results reporter to use
        # possible values: "dots", "progress"
        # available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ["progress"]


        # web server port
        port: 9876


        # enable / disable colors in the output (reporters and logs)
        colors: true


        # level of logging
        # possible values:
        # - config.LOG_DISABLE
        # - config.LOG_ERROR
        # - config.LOG_WARN
        # - config.LOG_INFO
        # - config.LOG_DEBUG
        logLevel: config.LOG_INFO


        # enable / disable watching file and executing tests whenever any file changes
        # autoWatch: true


        # start these browsers
        # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: [
            "PhantomJS"
        ]


        # Continuous Integration mode
        # if true, Karma captures browsers, runs the tests and exits
        singleRun: false
