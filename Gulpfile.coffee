gulp          = require("gulp-help")(require("gulp"))
coffee        = require "gulp-coffee"
coffeelint    = require "gulp-coffeelint"
jade          = require "gulp-jade"
templateCache = require "gulp-angular-templatecache"
concat        = require "gulp-concat"
uglify        = require "gulp-uglify"
gif           = require "gulp-if"
karma         = require "gulp-karma"
debug         = require "gulp-debug"
copy          = require "gulp-copy"
docco         = require "gulp-docco"
groc          = require "gulp-groc"
del           = require "del"
cache         = require "gulp-cached"
connect       = require "gulp-connect"
stylus        = require "gulp-stylus"
rename        = require "gulp-rename"
{protractor}  = require "gulp-protractor"

DOC_FILES = [
    "./README.MD"
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/*/**/*.coffee"
    "!./app/*/**/*-test.coffee"
    "!./app/**/*-e2e.coffee"
]

COPY_FILES =
    img:   "./app/statics/assets/images/**/*.*"
    css:   [
        "./bower_components/bootstrap/dist/css/bootstrap.min.css"
        "./bower_components/bootstrap/dist/css/bootstrap-theme.min.css"
        "./bower_components/bootstrap/dist/css/bootstrap.css.map"
        "./bower_components/bootstrap/dist/css/bootstrap-theme.css.map"
    ]
    js: [
        "./bower_components/bootstrap/dist/js/bootstrap.js"
    ]
    fonts: [
        "./app/statics/assets/fonts/*.*"
        "./bower_components/bootstrap/dist/fonts/*.*"
    ]


BASEURL = "http://localhost:3123"

E2E_FILES = "./app/**/*-e2e.coffee"

APP_FILES = "./app/**/*.coffee"

BUILD =
    files: [
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
        "!./app/*/**/*-test.coffee" #exclude test files
        "!./app/**/*-e2e.coffee"    #exclude e2e test files
        "./app/**/*.jade"
        "./app/statics/master.styl"
        "./app/**/*.styl"
    ]
    dirs:
        out: "./build"
        js:  "./build/js"
        css: "./build/css"
        fonts: "./build/fonts"
        images: "./build/images"
        docs: "./docs"
    module: "app"
    app: "app.js"
    css: "app.css"



gulp.task "lint",
    "Lints all CoffeeScript source files.",
    ->
        gulp.src APP_FILES
            .pipe coffeelint()
            .pipe coffeelint.reporter()


gulp.task "test",
    "Starts and reruns all tests on change of test or source files.",
    ->
        gulp.src []
            .pipe karma
                configFile: "karma.conf.coffee"
                action: "watch"

gulp.task "e2e",
    "Runs all e2e tests.",
    [
        "run"
    ],
    ->
        gulp.src E2E_FILES
            .pipe protractor
                configFile: "./protractor.config.coffee"
                args: [
                    "--baseUrl"
                    BASEURL
                ]


gulp.task "build",
    "Lints and builds the project to '#{BUILD.dirs.out}'.",
    [
        "lint"
        "copy"
    ],
    ->
        gulp.src BUILD.files
            .pipe cache( "build" )
            .pipe gif "*.coffee", continueOnError( coffee() )
            .pipe gif "*.jade", continueOnError( jade() )
            .pipe gif "*.styl", continueOnError( stylus() )
            .pipe gif "**/master.html", gulp.dest( BUILD.dirs.out )
            .pipe gif "*.html", templateCache( module: BUILD.module )
            .pipe gif "*.css", concat( BUILD.css )
            .pipe gif "*.css", gulp.dest( BUILD.dirs.css )
            .pipe gif "*.js", concat( BUILD.app )
            .pipe gulp.dest( BUILD.dirs.js )
            .pipe connect.reload()


gulp.task "build:production",
    "Lints, builds and minifies the project to '#{BUILD.dirs.out}'.",
    [
        "clean:build"
        "lint"
        "stylus"
        "copy:css"
        "copy:fonts"
        "copy:img"
    ],
    ->
        gulp.src BUILD.files
            .pipe cache( "build" )
            .pipe gif "*.coffee", coffee()
            .pipe gif "*.jade", jade()
            .pipe gif "**/index.html", gulp.dest( BUILD.dirs.out )
            .pipe gif "*.html", templateCache( module: BUILD.module )
            .pipe gif "*.js", concat( BUILD.app )
            .pipe uglify()
            .pipe gulp.dest( BUILD.dirs.js )

gulp.task "stylus",
  "Converts Stylus in CSS files",
  [],
  ->
    gulp.src BUILD.files
    .pipe gif "*.styl", continueOnError( stylus({ compress: true }) )
    .pipe gif "*.css", continueOnError( rename({ dirname: '' }) ) # remove sub-directories assets/css
    .pipe gif "*.css", gulp.dest( BUILD.dirs.css )


gulp.task "default",
    "Runs 'develop' and 'test'.",
    [
        "develop"
    ]


gulp.task "build:watch",
    "Runs 'build' and watches the source files, rebuilds the project on change.",
    [
        "build"
    ],
    ->
        watcher = gulp.watch BUILD.files, ["build"]

        watcher.on "change", ( event ) ->
            if event.type is "deleted"
                delete cache.caches[build][event.path]


gulp.task "develop",
    "Watches/Build and Test the source files on change.",
    [
        "build:watch"
        "test"
        "run"
    ]


gulp.task "dev",
    "Shorthand for develop.",
    [
        "develop"
    ]

gulp.task "copy",
    "Copy every assets to '#{BUILD.dirs.out}' dir.",
    [
        "copy:img"
        "copy:css"
        "copy:fonts"
        "copy:js"
    ]

gulp.task "copy:img",
    "Copy images to '#{BUILD.dirs.images}' dir.",
    ->
        gulp.src COPY_FILES.img
            .pipe gulp.dest BUILD.dirs.images

gulp.task "copy:css",
    "Copy css to '#{BUILD.dirs.css}' dir.",
    ->
        gulp.src COPY_FILES.css
            .pipe gulp.dest BUILD.dirs.css

gulp.task "copy:fonts",
    "Copy fonts to '#{BUILD.dirs.fonts}' dir.",
    ->
        gulp.src COPY_FILES.fonts
            .pipe gulp.dest BUILD.dirs.fonts

gulp.task "copy:js",
    "Copy js to '#{BUILD.dirs.out}' dir.",
    ->
        gulp.src COPY_FILES.js
            .pipe copy BUILD.dirs.out, prefix: 3

gulp.task "clean",
    "Clear '#{BUILD.dirs.out}' and '#{BUILD.dirs.docs}' folder.",
    ( cb ) ->
        del [BUILD.dirs.out, BUILD.dirs.docs], -> cb null, []


gulp.task "clean:build",
    "Cleans the '#{BUILD.dirs.out}' directory",
    ( cb ) ->
        del BUILD.dirs.out, -> cb null, []

gulp.task "clean:docs",
    "Cleans the '#{BUILD.dirs.docs}' directory",
    ( cb ) ->
        del BUILD.dirs.docs, -> cb null, []

gulp.task "docs",
    "Generates documentation in '#{BUILD.dirs.docs}' directory",
    [ "clean:docs" ]
    ->
        gulp.src DOC_FILES
            .pipe groc( out: BUILD.dirs.docs )

serverStarted = false
gulp.task "run", "Serves the App.", ->
    return if serverStarted
    serverStarted = true

    connect.server
        root: BUILD.dirs.out
        livereload: true
        port: 3123
        fallback: BUILD.dirs.out + "/statics/master.html"


# clean stream of onerror

continueOnError = ( stream ) ->
    stream.on "error", ( err ) ->
            console.log err
        .on "newListener", ->
            cleaner @

cleaner = ( stream ) ->
    stream.listeners( "error" ).forEach ( item ) ->
        if item.name is "onerror" then @.removeListener "error", item
    , stream

