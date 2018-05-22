# Vidatio-Website

Authors:
- Lukas Wanko
- Christian Lehner
- Fabio Batz
- Andreas Frank
- Georg Eschbacher

and a lot more...

# Readme

## File structure
```
 ├── .bowerrc
 ├── .editorconfig
 ├── .gitignore
 ├── .git
 │     ├──*
 │     *
 ├── Gulpfile.coffee
 ├── Gulpfile.js
 ├── bower.json
 ├── bower_components
 ├── README.md
 ├── LICENSE
 ├── app
 │    ├──  app.coffee
 │    ├──  app-test.coffee
 │    ├──  app-controller.coffee
 │    ├──  app-controller-test.coffee
 │    ├── components
 │    │    ├── user
 │    │    │    ├── user.coffee
 │    │    │    ├── factory.coffee
 │    │    │    ├── factory-test.coffee
 │    │    │    ├── service.coffee
 │    │    │    ├── service-test.coffee
 │    │    │    ├── directivy.coffee
 │    │    │    └── directivy-test.coffee
 │    ├── user
 │    │    ├── controller.coffee
 │    │    ├── controller-test.coffee
 │    │    ├── user.jade
 │    │    └── user.styl
 │    ├── statics
 │    │    ├── header.jade
 │    │    ├── header.styl
 │    │    ├── master.jade
 │    │    ├── master.styl
 │    │    ├── footer.jade
 │    │    ├── footer.styl
 │    │    ├── error.jade
 │    │    ├── error.styl
 │    │    ├── includes
 │    │    │    ├── js.jade
 │    │    │    └── styl.jade
 │    │    ├── assets
 │    │    │    ├── images
 │    │    │    │     ├──*
 │    │    │    │     *
 │    │    │    ├── fonts
 │    │    │    │     ├──*
 │    │    │    │     *
 │    │    │    ├── styl
 │    │    │    │     └──*
 ├── build
 │    ├──*
 │    *
 └── docs
      └──*
```

## Testing

### Client
All test are stored in the corresponding folder as it is shown in the [file structure](code#file-structure). The unit tests are executed automatically with ```gulp``` and ```gulp dev```.

#### Unit Test
We are using [karma](http://karma-runner.github.io/index.html) as testrunner with following config file *karma.conf.coffee*. As test framework we use [jasmine](http://jasmine.github.io/). All test files are in the same folder where the FUT (file under test) is, if you want to test the file `appleJuiceMaker.js`, the corresponding test file has to be `appleJuiceMaker-test.js`.

Run unit tests
```
gulp test
```

#### E2E Test
For e2e-tests we are using [protractor](https://angular.github.io/protractor/#/). Same naming conventions apply for e2e tests like for unit tests except that they end with `-e2e.js`. Before running e2e tests the first time, update your webdriver with the following command:

```
./node_modules/protractor/bin/webdriver-manager update
```
Afterwards you are ready to run e2e tests with:
```
gulp e2e
```

### Server
We are testing the server with [frisbyjs](http://frisbyjs.com). To run the specs, execute
```bash
jasmine-node /directory-of-specs/
```

## Documentation
We are using [groc](https://github.com/nevir/groc) to automatically generate a documentation from comments. The Documentation can be generated with `gulp docs`, target directory is `./docs`. To generate the docs **groc** needs to be installed globally with `npm install -g groc`.

Genereate documentation
1. ```npm install```
2. ```npm install -g groc```
3. ```gulp docs```
4. Open browser and type in file url path/to/project/docs/

## Gulp
Self-explanatory. Here's the output from `gulp help`:

```
add list here
```

## Linting
There's a [CoffeeScript Style Guide](https://github.com/polarmobile/coffeescript-style-guide), you can modify the `coffeelint.json` file for your needs (e.g. 4 spaces instead of 2).

## EditorConfig
The `.editorconfig` contains all relevant styles for your editor, your IDE/Editor should support it, otherwise install a plugin from [editorconfig.org](http://editorconfig.org/).

## Visualizations

For visualizations of geo coded data the library [Leaflet.js](http://leafletjs.com/) is used.

## Some thoughts
The application is designed in a highly modularized way.

* The `app` folder contains the main application, it should serve the website.
    * `app.coffee` &rArr; is the main entry point of the application. Dependencies are injected and routes are created here.
    * `init-deps.coffee` &rArr; declares a scope for directives, controllers, filters and services in order to make shure these modules are available in each use case.
    * Each subfolder of `app/*` except `app/components` and `app/statics` has its own controller, style and markup files.
    * `app/statics` provides overall layout files and assets like stylus mixins, helper functions etc.
    * `app/components/*` holds all services, factories and directives of a feature

