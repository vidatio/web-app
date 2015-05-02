gulp          = require("gulp-help")(require("gulp"))
coffee        = require "gulp-coffee"
coffeelint    = require "gulp-coffeelint"
jade          = require "gulp-jade"
templateCache = require "gulp-angular-templatecache"
concat        = require "gulp-concat"
uglify        = require "gulp-uglify"
gif           = require "gulp-if"
karma         = require "gulp-karma"
shell         = require "gulp-shell"
debug         = require "gulp-debug"
copy          = require "gulp-copy"
docco         = require "gulp-docco"
groc          = require "gulp-groc"
clean         = require "gulp-clean"

connect = require "gulp-connect"
{protractor} = require "gulp-protractor"

BUILD_FILES = [
    "./bower_components/jquery/dist/jquery.js"
    "./bower_components/angular/angular.js"
    "./bower_components/angular-route/angular-route.js"
    "./bower_components/angular-resource/angular-resource.js"
    "./bower_components/angular-animate/angular-animate.js"
    "./bower_components/angular-cookies/angular-cookies.js"
    "./bower_components/angular-bootstrap/ui-bootstrap-tpls.js"
    "./bower_components/ng-file-upload/angular-file-upload.js"
    "./bower_components/angular-ui-router/release/angular-ui-router.js"
    "./bower_components/bootstrap/dist/js/bootstrap.js"
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/*/**/*.coffee"
    "!./app/*/**/*_test.coffee" #exclude test files
    "!./app/**/*_e2e.coffee" #exclude e2e test files
    "./app/**/*.jade"
]

DOC_FILES = [
    "./README.md"
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/*/**/*.coffee"
    "!./app/*/**/*_test.coffee"
    "!./app/**/*_e2e.coffee"
]

COPY_FILES =
    img:   "./app/images/**/**.*"
    css:   [
        "./bower_components/bootstrap/dist/css/bootstrap.css"
        "./bower_components/bootstrap/dist/css/bootstrap-theme.css"
        "./bower_components/bootstrap/dist/css/bootstrap.css.map"
        "./bower_components/bootstrap/dist/css/bootstrap-theme.css.map"
    ]
    js: [
        "./bower_components/bootstrap/dist/js/bootstrap.js"
    ]
    fonts: "./bower_components/bootstrap/dist/fonts/*.*"

gulp.task "lint",
    "Lints all CoffeeScript source files.",
    ->
        gulp.src "./app/**/*.coffee"
            .pipe(coffeelint())
            .pipe(coffeelint.reporter())


gulp.task "test",
    "Starts and reruns all tests on change of test or source files.",
    ->
        gulp.src []
            .pipe karma(
                configFile: "karma.conf.coffee"
                action: "watch"
            )

gulp.task "e2e",
    "Runs all e2e tests.",
    ->
        gulp.src ["./app/**/*_e2e.coffee"]
            .pipe protractor
                configFile: "./protractor.config.coffee",
                args: ["--baseUrl", "http://127.0.0.1:3123"]


gulp.task "build",
    "Lints and builds the project to './build/'.",
    [
        "lint"
        "copy"
    ],
    ->
        gulp.src BUILD_FILES
            .pipe gif( "*.coffee", continueOnError(coffee()) )
            .pipe gif( "*.jade", continueOnError(jade()) )
            .pipe gif( "**/index.html", gulp.dest("./build/") )
            .pipe gif( "*.html", templateCache(module: "animals") )
            .pipe gif( "*.js", concat("app.js") )
            .pipe gulp.dest("./build/js/")
            .pipe connect.reload()


gulp.task "build:production",
    "Lints, builds and minifies the project to './build/'.",
    [ "lint" ],
    ->
        gulp.src BUILD_FILES
            .pipe gif("*.coffee", coffee())
                .on "error", (error) ->
                    console.error 'CoffeeScript Compile Error: ', error
            .pipe gif("*.jade", jade())
            .pipe gif("**/index.html", gulp.dest("./build/"))
            .pipe gif "*.html", templateCache(module: "animals")
            .pipe gif("*.js", concat("app.js"))
            .pipe uglify()
            .pipe gulp.dest("./build/js/")


gulp.task "default",
    "Runs 'develop' and 'test'.",
    [ "develop" ]


gulp.task "build:watch",
    "Runs 'build' and watches the source files, rebuilds the project on change.",
    [ "build" ],
    ->
        gulp.watch ["app/**/*.coffee", "app/**/*.jade"], ["build"]

gulp.task "develop",
    "Watches/Build and Test the source files on change.",
    [
        "build:watch"
        "test"
    ]


gulp.task "dev",
    "Shorthand for develop.",
    [
        "develop"
    ]

gulp.task "copy",
    "Copy every assets to './build/' dir.",
    [
        "copy:img"
        "copy:css"
        "copy:fonts"
        "copy:js"
    ]

gulp.task "copy:img",
    "Copy images to './build/' dir.",
    ->
        gulp.src COPY_FILES.img
            .pipe copy "./build/", prefix: 1

gulp.task "copy:css",
    "Copy css to './build/' dir.",
    ->
        gulp.src COPY_FILES.css
            .pipe copy "./build/", prefix: 3

gulp.task "copy:fonts",
    "Copy fonts to './build/' dir.",
    ->
        gulp.src COPY_FILES.fonts
            .pipe copy "./build/", prefix: 3

gulp.task "copy:js",
    "Copy js to './build/' dir.",
    ->
        gulp.src COPY_FILES.js
            .pipe copy "./build/", prefix: 3

gulp.task "clean",
    "Clear './build/' and './docs/' folder.",
    (cb) ->
        gulp.src ["./docs", "./build"], read: false
            .pipe clean()


gulp.task "docs:clean",
    "Cleans the docs directory",
    ->
        gulp.src ["./docs"], read: false
            .pipe clean()

gulp.task "docs",
    "Generates documentation in 'docs' directory",
    [ "docs:clean" ]
    ->
        gulp.src DOC_FILES
            .pipe groc( out: "./docs" )

serverStarted = false
gulp.task "run", "Serves the App.", ->
    return if serverStarted
    serverStarted = true

    connect.server
        root: "./build"
        livereload: true
        port: 3123


# clean stream of onerror

continueOnError = (stream) ->
    stream
        .on 'error', (err) ->
            console.log err
            return
        .on 'newListener', ->
            cleaner @

cleaner = (stream) ->
    stream.listeners('error').forEach( (item) ->
        if (item.name is 'onerror') then @.removeListener('error', item)
    , stream)

