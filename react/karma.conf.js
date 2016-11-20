var path = require('path');
var webpack = require('webpack');

module.exports = function(config) {
  config.set({
    // use the PhantomJS browser
    browsers: ['PhantomJS'],

    // use the Jasmine testing framework
    frameworks: ['jasmine'],

    // files that Karma will server to the browser
    files: [
      // load fixtures
      'test/fixtures/**/*.json',
      // use Babel polyfill to emulate a full ES6 environment in PhantomJS
      '../node_modules/babel-polyfill/dist/polyfill.js',
      // use whatwg-fetch polyfill
      '../node_modules/whatwg-fetch/fetch.js',
      // entry file for Webpack
      'test/testHelper.js'
    ],

    proxies: {
      '/test/support/images': '/base/test/support/images'
    },

    // before serving test/testHelper.js to the browser
    preprocessors: {
      // process json files with karma-json-fixtures-preprocessor
      'test/fixtures/**/*.json': ['json_fixtures'],
      'test/testHelper.js': [
        // use karma-webpack to preprocess the file via webpack
        'webpack',
        // use karma-sourcemap-loader to utilize sourcemaps generated by webpack
        'sourcemap'
      ]
    },

    // webpack configuration used by karma-webpack
    webpack: {
      // generate sourcemaps
      devtool: 'inline-source-map',
      // enzyme-specific setup
      externals: {
        'cheerio': 'window',
        'react/addons': true,
        'react/lib/ExecutionEnvironment': true,
        'react/lib/ReactContext': true
      },
      module: {
        loaders: [
          {
            include: /\.json$/,
            loader: 'json-loader'
          },
          // use babel-loader to transpile the test and src folders
          {
            test: /\.jsx?$/,
            exclude: /node_modules/,
            loader: 'babel'
          }
        ]
      },

      // set NODE_ENV to test
      plugins: [
        new webpack.DefinePlugin({ 'process.env.NODE_ENV': '"test"' })
      ],

      // relative path starts out at the src folder when importing modules
      resolve: {
        root: path.resolve(__dirname, 'src'),
        extensions: ['', '.json', '.jsx', '.js']
      }
    },

    webpackMiddleware: {
      // do not output webpack build information to the browser's console
      noInfo: true
    },

    // test reporters that Karma should use
    reporters: [
      // use karma-spec-reporter to report results to the browser's console
      'spec'
    ],

    jsonFixturesPreprocessor: {
      stripPrefix: 'test/fixtures/'
    },

    // karma-spec-reporter configuration
    specReporter: {
      suppressErrorSummary: true,  // do not print error summary

      // remove meaningless stack trace when tests do not pass
      maxLogLines: 2,

      // do not print information about tests that are passing
      suppressPassed: true,
      suppressSkipped: true
    }
  })
}