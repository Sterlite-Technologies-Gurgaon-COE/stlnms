(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else {
		var a = factory();
		for(var i in a) (typeof exports === 'object' ? exports : root)[i] = a[i];
	}
})(window, function() {
return (window["webpackJsonp"] = window["webpackJsonp"] || []).push([["loader"],{

/***/ "./src/main/assets/modules/lib/loader/index.ts":
/*!*****************************************************!*\
  !*** ./src/main/assets/modules/lib/loader/index.ts ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _Object$defineProperty2 = __webpack_require__(/*! @babel/runtime-corejs3/core-js-stable/object/define-property */ "./node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property.js");

_Object$defineProperty2(exports, "__esModule", {
  value: true
});

exports.default = void 0;

var _defineProperty2 = _interopRequireDefault(__webpack_require__(/*! ../../../../../../node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property */ "./node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property.js"));

var _setTimeout2 = _interopRequireDefault(__webpack_require__(/*! ../../../../../../node_modules/@babel/runtime-corejs3/core-js-stable/set-timeout */ "./node_modules/@babel/runtime-corejs3/core-js-stable/set-timeout.js"));

var _set = _interopRequireDefault(__webpack_require__(/*! ../../../../../../node_modules/@babel/runtime-corejs3/core-js-stable/set */ "./node_modules/@babel/runtime-corejs3/core-js-stable/set.js"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; (0, _defineProperty2.default)(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _defineProperty(obj, key, value) { if (key in obj) { (0, _defineProperty2.default)(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/* eslint no-console: 0 */
var OnmsLoader =
/*#__PURE__*/
function () {
  function OnmsLoader(prefix, extension) {
    _classCallCheck(this, OnmsLoader);

    _defineProperty(this, "prefix", '/opennms/assets/');

    _defineProperty(this, "extension", '.vaadin.js');

    _defineProperty(this, "loaded", new _set.default());

    _defineProperty(this, "mappings", void 0);

    if (prefix) {
      this.prefix = prefix;
    }

    if (extension) {
      this.extension = extension;
    }

    this.mappings = {
      'backshift': this.prefix + 'backshift-js' + this.extension,
      'bootstrap': this.prefix + 'bootstrap-js' + this.extension,
      'd3': this.prefix + 'd3-js' + this.extension,
      'flot': this.prefix + 'flot-js' + this.extension,
      'global': this.prefix + 'global' + this.extension,
      'holder': this.prefix + 'holder-js' + this.extension,
      'ionicons-css': this.prefix + 'ionicons-css' + this.extension,
      'jquery': this.prefix + 'jquery-js' + this.extension,
      'jquery-ui': this.prefix + 'jquery-ui-js' + this.extension,
      'leaflet': this.prefix + 'leaflet-js' + this.extension,
      'manifest': this.prefix + 'manifest' + this.extension,
      'onms-graph': this.prefix + 'onms-graph' + this.extension,
      //      'openlayers': this.prefix + 'legacy/openlayers-2.10/OpenLayers.js',
      'vendor': this.prefix + 'vendor' + this.extension
    };
  }

  _createClass(OnmsLoader, [{
    key: "load",
    value: function load() {
      for (var _len = arguments.length, modules = new Array(_len), _key = 0; _key < _len; _key++) {
        modules[_key] = arguments[_key];
      }

      console.log('OnmsLoader: loading ' + modules.length + ' modules.');
      var fragment = document.createDocumentFragment();

      for (var _i = 0, _modules = modules; _i < _modules.length; _i++) {
        var module = _modules[_i];

        if (this.loaded[module]) {
          console.log('OnmsLoader: skipping ' + module + ' (already loaded)');
        } else {
          if (this.mappings[module]) {
            console.debug('OnmsLoader: loading ' + module);
            var el = document.createElement('script');
            el.src = this.mappings[module];
            el.async = false;
            fragment.appendChild(el);
            this.loaded[module] = true;
          } else {
            console.error('OnmsLoader: no mapping for module "' + module + '"!');
          }
        }
      }

      document.body.appendChild(fragment);
      console.log('OnmsLoader: finished loading modules');
    }
  }, {
    key: "waitFor",
    value: function waitFor(name, check, onready) {
      var _this = this;

      var retry = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : 50;

      if (check()) {
        console.log('OnmsLoader: ' + name + ' is ready.');
        onready();
      } else if (retry < 10000) {
        var nextRetry = Math.round(retry * 1.5);
        console.log('OnmsLoader: ' + name + ' is not ready. Trying again in ' + nextRetry + 'ms.');
        (0, _setTimeout2.default)(function () {
          _this.waitFor(name, check, onready, nextRetry);
        }, nextRetry);
      } else {
        console.log('OnmsLoader: giving up on ' + name);
      }
    }
  }]);

  return OnmsLoader;
}();

exports.default = OnmsLoader;

/***/ })

},[["./src/main/assets/modules/lib/loader/index.ts","vendor"]]]);
});
//# sourceMappingURL=loader.js.map