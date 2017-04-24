var webpack = require('webpack')
var path = require('path')

module.exports = {
  devtool: 'source-map',
  entry: [
    'babel-polyfill',
    './web_client/main.js'
  ],
  output: {
    path: path.resolve('./app/assets/javascripts/build'),
    filename: 'bundle.js'
  },
  resolve: {
    modules: [
      path.resolve('./web_client'),
      path.resolve('./node_modules')
    ]
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }, {
        test: /\.json$/,
        loader: 'json-loader'
      }
    ]
  }
}
