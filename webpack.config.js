const webpack = require('webpack');
var fs = require('fs');
const path = require('path');
const autoprefixer = require('autoprefixer');


// FRONTEND

let frontendConfig = {

  name: 'frontend',
  target: 'web',

  entry: {
    main: [
      './src/frontend/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist/frontend'),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          'sass-loader'
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  postcss: [
    autoprefixer({ browsers: ['last 2 versions'] }) 
  ]

};


// BACKEND

const nodeModules = {};
fs.readdirSync('node_modules')
  .filter(x => ['.bin'].indexOf(x) === -1)
  .forEach((mod) => {
    nodeModules[mod] = `commonjs ${mod}`;
  });

const backendConfig = {

  name: 'backend',
  target: 'node',
  externals: nodeModules,

  node: {
    __dirname: true,
    __filename: true,
    process: true
  },

  entry: {
    index: [
      './src/backend/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist/backend'),
    filename: '[name].js'
  }

}


// DEVELOPMENT / PRODUCTION

let config;
if (process.env.NODE_ENV === 'production') {
  frontendConfig = Object.assign(frontendConfig, {

    plugins: [
      new webpack.optimize.UglifyJsPlugin({
        compress: { warnings: false }
      }),
      new webpack.optimize.OccurrenceOrderPlugin()
    ]

  });

  config = [ frontendConfig, backendConfig ];
} else {
  frontendConfig = Object.assign(frontendConfig, {

    devServer: {
      inline: true,
      stats: {
        colors: true,
        hash: false,
        timings: true,
        chunks: false,
        chunkModules: false,
        modules: false
      }
    }

  });

  config = frontendConfig;
}

module.exports = config;
