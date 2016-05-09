var webpack = require('webpack');

module.exports = {
  devtool: "source-map",
  entry: ["./web_client/main.js"],
  output: {
    path: "./app/assets/javascripts/build",
    filename: "bundle.js"
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      }, {
        test: /\.json$/,
        loader: 'json-loader'
      }
    ]
  }
};
