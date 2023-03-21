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
return (window["webpackJsonp"] = window["webpackJsonp"] || []).push([["onms-pagination"],{

/***/ "./src/main/assets/js/lib/onms-pagination/index.js":
/*!*********************************************************!*\
  !*** ./src/main/assets/js/lib/onms-pagination/index.js ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var angular = __webpack_require__(/*! ../../vendor/angular-js */ "./src/main/assets/js/vendor/angular-js.js");

var paginationTemplate = __webpack_require__(/*! ./pagination-toolbar.html */ "./src/main/assets/js/lib/onms-pagination/pagination-toolbar.html");

var MODULE_NAME = 'onms.pagination';
angular.module(MODULE_NAME, ['ui.bootstrap']).directive('pagination', function () {
  return {
    restrict: 'E',
    scope: {
      model: '=model',
      position: '@position',
      onChangeCallback: '=onChange'
    },
    link: function link(scope, element, attrs) {
      if (scope.model === undefined) {
        throw new Error('No model defined.');
      }

      if (scope.model.page === undefined) {
        throw new Error('No attribute model.page defined');
      }

      if (scope.model.totalItems === undefined) {
        throw new Error('No attribute model.totalItems defined');
      }

      if (scope.model.limit === undefined) {
        throw new Error('No attribute model.limit defined');
      }

      var currentPage = scope.model.page;

      scope.onChange = function () {
        if (currentPage !== scope.model.page) {
          currentPage = scope.model.page;

          if (scope.onChangeCallback) {
            scope.onChangeCallback();
          }
        }
      };
    },
    transclude: true,
    templateUrl: paginationTemplate
  };
});

/***/ }),

/***/ "./src/main/assets/js/lib/onms-pagination/pagination-toolbar.html":
/*!************************************************************************!*\
  !*** ./src/main/assets/js/lib/onms-pagination/pagination-toolbar.html ***!
  \************************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

var path = '/home/kevlin/Documents/UAT_branch/core/web-assets/src/main/assets/js/lib/onms-pagination/pagination-toolbar.html';
var html = "<div>\n    <!-- Content for pagination -->\n    <div ng-transclude ng-if=\"position === 'bottom'\"></div>\n\n    <!-- Paging controls -->\n    <div class=\"row\">\n        <div class=\"col-md-4 col-lg-6 col-sm-12\" ng-show=\"(model.totalItems / model.limit) > 1\">\n            <div style=\"margin: 0px;\"\n                 uib-pagination\n                 ng-model=\"model.page\"\n                 total-items=\"model.totalItems\"\n                 items-per-page=\"model.limit\"\n                 rotate=\"true\"\n                 boundary-links=\"true\"\n                 max-size=\"5\"\n                 boundary-link-numbers=\"true\"\n                 ng-change=\"onChange()\">\n            </div>\n        </div>\n        <div class=\"col-md-8 col-lg-6 col-sm-12 mt-4\">\n            <pre class=\"pull-right\" ng-show=\"model.totalItems == 0\">No items found.</pre>\n            <pre class=\"pull-right\" ng-show=\"model.totalItems > 0\">{{model.totalItems / model.page === 1\n            ? \"Item \" + (model.offset + 1)\n            : \"Items \" + ((model.page - 1) * model.limit + 1) + \" - \" + (model.page * model.limit > model.totalItems ? model.totalItems : model.page * model.limit)}} ({{model.totalItems}} total)</pre>\n        </div>\n    </div>\n\n    <!-- Content for pagination -->\n    <div ng-transclude ng-if=\"position === 'top' || position === undefined\"></div>\n\n</div>";
window.angular.module('ng').run(['$templateCache', function(c) { c.put(path, html) }]);
module.exports = path;

/***/ }),

/***/ "./src/main/assets/js/vendor/angular-js.js":
/*!*************************************************!*\
  !*** ./src/main/assets/js/vendor/angular-js.js ***!
  \*************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/* Angular Core */
var angular = __webpack_require__(/*! ../../../../../node_modules/angular */ "./node_modules/angular/index.js-exposed");

__webpack_require__(/*! ../../../../../node_modules/angular-animate */ "./node_modules/angular-animate/index.js");

__webpack_require__(/*! ../../../../../node_modules/angular-cookies */ "./node_modules/angular-cookies/index.js");

__webpack_require__(/*! ../../../../../node_modules/angular-route */ "./node_modules/angular-route/index.js");

__webpack_require__(/*! ../../../../../node_modules/angular-resource */ "./node_modules/angular-resource/index.js");

__webpack_require__(/*! ../../../../../node_modules/angular-sanitize */ "./node_modules/angular-sanitize/index.js");
/* 3rd-Party Modules */


__webpack_require__(/*! ../../../../../node_modules/angular-growl-v2/build/angular-growl.min */ "./node_modules/angular-growl-v2/build/angular-growl.min.js");

__webpack_require__(/*! ../../../../../node_modules/angular-loading-bar */ "./node_modules/angular-loading-bar/index.js");

__webpack_require__(/*! ../../../../../node_modules/angular-growl-v2/build/angular-growl.css */ "./node_modules/angular-growl-v2/build/angular-growl.css");

__webpack_require__(/*! ../../../../../node_modules/angular-loading-bar/build/loading-bar.css */ "./node_modules/angular-loading-bar/build/loading-bar.css");
/* Bootstrap UI */


__webpack_require__(/*! ./bootstrap-js */ "./src/main/assets/js/vendor/bootstrap-js.js");

__webpack_require__(/*! ../../../../../node_modules/angular-bootstrap-checkbox/angular-bootstrap-checkbox */ "./node_modules/angular-bootstrap-checkbox/angular-bootstrap-checkbox.js");

__webpack_require__(/*! ../../../../../node_modules/ui-bootstrap4 */ "./node_modules/ui-bootstrap4/index.js"); // angular-ui-boostrap for bootstrap 4


console.log('init: angular-js'); // eslint-disable-line no-console

module.exports = window['angular'] = angular;

/***/ }),

/***/ "./src/main/assets/js/vendor/bootstrap-js.js":
/*!***************************************************!*\
  !*** ./src/main/assets/js/vendor/bootstrap-js.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


console.log('init: bootstrap-js'); // eslint-disable-line no-console

var jQuery = __webpack_require__(/*! ./jquery-js */ "./src/main/assets/js/vendor/jquery-js.js");

__webpack_require__(/*! ../../../../../node_modules/bootstrap/dist/js/bootstrap */ "./node_modules/bootstrap/dist/js/bootstrap.js");

module.exports = jQuery;

/***/ }),

/***/ "./src/main/assets/js/vendor/jquery-js.js":
/*!************************************************!*\
  !*** ./src/main/assets/js/vendor/jquery-js.js ***!
  \************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


console.log('init: jquery-js'); // eslint-disable-line no-console

var jQuery = __webpack_require__(/*! ../../../../../node_modules/jquery/dist/jquery */ "./node_modules/jquery/dist/jquery.js-exposed");

module.exports = jQuery;

/***/ })

},[["./src/main/assets/js/lib/onms-pagination/index.js","vendor"]]]);
});
//# sourceMappingURL=onms-pagination.js.map