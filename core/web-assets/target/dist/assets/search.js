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
return (window["webpackJsonp"] = window["webpackJsonp"] || []).push([["search"],{

/***/ "./src/main/assets/js/apps/search/index.js":
/*!*************************************************!*\
  !*** ./src/main/assets/js/apps/search/index.js ***!
  \*************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
* @author Alejandro Galue <agalue@opennms.org>
* @copyright 2016-2017 The OpenNMS Group, Inc.
*/


var _util = _interopRequireDefault(__webpack_require__(/*! ../../../modules/lib/util */ "./src/main/assets/modules/lib/util/index.js"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var angular = __webpack_require__(/*! ../../vendor/angular-js */ "./src/main/assets/js/vendor/angular-js.js");

__webpack_require__(/*! ../../lib/onms-http */ "./src/main/assets/js/lib/onms-http/index.js");

var kscTemplate = __webpack_require__(/*! ./template.ksc.html */ "./src/main/assets/js/apps/search/template.ksc.html");

var nodesTemplate = __webpack_require__(/*! ./template.nodes.html */ "./src/main/assets/js/apps/search/template.nodes.html");

angular.module('onms-search', ['onms.http', 'ui.bootstrap']).directive('onmsSearchNodes', function () {
  return {
    restrict: 'E',
    transclude: true,
    templateUrl: nodesTemplate,
    controller: 'NodeSearchCtrl'
  };
}).directive('onmsSearchKsc', function () {
  return {
    restrict: 'E',
    transclude: true,
    templateUrl: kscTemplate,
    controller: 'KscSearchCtrl'
  };
}).controller('NodeSearchCtrl', ['$scope', '$window', '$http', function ($scope, $window, $http) {
  $scope.getNodes = function (criteria) {
    return $http({
      url: 'rest/nodes',
      method: 'GET',
      params: {
        label: criteria,
        comparator: 'contains'
      }
    }).then(function (response) {
      return response.data.node;
    });
  };

  $scope.goToChooseResources = function (node) {
    $window.location.href = _util.default.getBaseHref() + 'graph/chooseresource.jsp?node=' + node.id;
  };
}]).controller('KscSearchCtrl', ['$scope', '$window', '$http', '$filter', function ($scope, $window, $http, $filter) {
  $scope.getKscReports = function (criteria) {
    return $http({
      url: 'rest/ksc',
      method: 'GET'
    }).then(function (response) {
      return $filter('filter')(response.data.kscReport, criteria);
    });
  };

  $scope.goToKscReport = function (ksc) {
    $window.location.href = _util.default.getBaseHref() + 'KSC/customView.htm?type=custom&report=' + ksc.id;
  };
}]);

/***/ }),

/***/ "./src/main/assets/js/apps/search/template.ksc.html":
/*!**********************************************************!*\
  !*** ./src/main/assets/js/apps/search/template.ksc.html ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

var path = '/home/administrator/Desktop/testnms/core/web-assets/src/main/assets/js/apps/search/template.ksc.html';
var html = "<div class=\"form-group\">\n  <div class=\"input-group\">\n    <input type=\"text\" class=\"form-control\" ng-model=\"asyncKsc\" placeholder=\"Type the KSC report name\"\n      uib-typeahead=\"ksc as ksc.label for ksc in getKscReports($viewValue)\"\n      typeahead-editable=\"false\"\n      typeahead-loading=\"kscLoadingNodes\"\n      typeahead-no-results=\"kscNoResults\"\n      typeahead-min-length=\"1\"\n      typeahead-on-select=\"goToKscReport($item)\"/>\n    <div class=\"input-group-append\">\n      <span class=\"input-group-text\"><i class=\"fa fa-search\"></i></span>\n    </div>\n  </div>\n  <i ng-show=\"kscLoadingNodes\" class=\"fa fa-refresh\"></i>\n  <p class=\"form-text text-muted\" ng-show=\"kscNoResults\">\n    <i class=\"fa fa-remove\"></i> No Results Found\n  </p>\n</div>\n";
window.angular.module('ng').run(['$templateCache', function(c) { c.put(path, html) }]);
module.exports = path;

/***/ }),

/***/ "./src/main/assets/js/apps/search/template.nodes.html":
/*!************************************************************!*\
  !*** ./src/main/assets/js/apps/search/template.nodes.html ***!
  \************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

var path = '/home/administrator/Desktop/testnms/core/web-assets/src/main/assets/js/apps/search/template.nodes.html';
var html = "<div class=\"form-group\">\n  <div class=\"input-group\">\n    <input type=\"text\" class=\"form-control\" ng-model=\"asyncNode\" placeholder=\"Type the node label\"\n      uib-typeahead=\"node as node.label for node in getNodes($viewValue)\"\n      typeahead-editable=\"false\"\n      typeahead-loading=\"nodeLoadingNodes\"\n      typeahead-no-results=\"nodeNoResults\"\n      typeahead-min-length=\"1\"\n      typeahead-on-select=\"goToChooseResources($item)\"/>\n    <div class=\"input-group-append\">\n      <span class=\"input-group-text\"><i class=\"fa fa-search\"></i></span>\n    </div>\n  </div>\n  <i ng-show=\"nodeLoadingNodes\" class=\"fa fa-refresh\"></i>\n  <p class=\"form-text text-muted\" ng-show=\"nodeNoResults\">\n    <i class=\"fa fa-remove\"></i> No Results Found\n  </p>\n</div>\n";
window.angular.module('ng').run(['$templateCache', function(c) { c.put(path, html) }]);
module.exports = path;

/***/ }),

/***/ "./src/main/assets/js/lib/onms-http/403-permission-denied.html":
/*!*********************************************************************!*\
  !*** ./src/main/assets/js/lib/onms-http/403-permission-denied.html ***!
  \*********************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

var path = '/home/administrator/Desktop/testnms/core/web-assets/src/main/assets/js/lib/onms-http/403-permission-denied.html';
var html = "<div class=\"modal-header\">\n    <h3><i class=\"fa fa-exclamation-triangle text-warning\"></i> Permission Denied</h3>\n</div>\n<div class=\"modal-body\">\n    <h5>\n        You are not allowed to perform the requested action.\n    </h5>\n    <p class=\"text-muted\">\n        This is not supposed to happen.\n        Please reload the page and contact your administrator if this occurs more often.\n    </p>\n</div>\n<div class=\"modal-footer\">\n    <button class=\"btn btn-primary\" ng-click=\"reload()\">Reload</button>\n</div>";
window.angular.module('ng').run(['$templateCache', function(c) { c.put(path, html) }]);
module.exports = path;

/***/ }),

/***/ "./src/main/assets/js/lib/onms-http/index.js":
/*!***************************************************!*\
  !*** ./src/main/assets/js/lib/onms-http/index.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _startsWith = _interopRequireDefault(__webpack_require__(/*! ../../../../../../node_modules/@babel/runtime-corejs3/core-js-stable/instance/starts-with */ "./node_modules/@babel/runtime-corejs3/core-js-stable/instance/starts-with.js"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var angular = __webpack_require__(/*! ../../vendor/angular-js */ "./src/main/assets/js/vendor/angular-js.js");

var permissionDeniedTemplate = __webpack_require__(/*! ./403-permission-denied.html */ "./src/main/assets/js/lib/onms-http/403-permission-denied.html");

angular.module('onms.http', ['ui.bootstrap']).factory('InterceptorService', ['$q', '$rootScope', function ($q, $rootScope) {
  return {
    responseError: function responseError(rejection) {
      if (rejection.status === 401) {
        var _context, _context2;

        if (rejection.config && rejection.config.url && ((0, _startsWith.default)(_context = rejection.config.url).call(_context, 'rest/') || (0, _startsWith.default)(_context2 = rejection.config.url).call(_context2, 'api/v2/'))) {
          console.error('Login Required', rejection, rejection.headers); // eslint-disable-line no-console

          $rootScope.$emit('loginRequired');
        }
      }

      if (rejection.status === 403) {
        $rootScope.$emit('permissionDenied');
      }

      return $q.reject(rejection);
    }
  };
}]).config(['$httpProvider', function ($httpProvider) {
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
  $httpProvider.interceptors.push('InterceptorService');
}]).run(['$rootScope', '$uibModal', function ($rootScope, $uibModal) {
  $rootScope.$on('loginRequired', function () {
    var baseTags = document.getElementsByTagName('base');

    if (baseTags && baseTags.length > 0 && baseTags[0].href) {
      window.location.href = baseTags[0].href + 'login.jsp?session_expired=true';
    } else {
      console.warn('Login is required, but cannot forward to login page due to missing base tag.'); // eslint-disable-line no-console
    }
  });
  $rootScope.$on('permissionDenied', function () {
    $uibModal.open({
      templateUrl: permissionDeniedTemplate,
      controller: ["$scope", "$uibModalInstance", function controller($scope, $uibModalInstance) {
        $scope.reload = function () {
          $uibModalInstance.dismiss();
          window.location.reload();
        };
      }],
      size: '',
      backdrop: 'static',
      keyboard: false
    });
  });
}]);
module.exports = angular;

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

/***/ }),

/***/ "./src/main/assets/modules/lib/util/index.js":
/*!***************************************************!*\
  !*** ./src/main/assets/modules/lib/util/index.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _Object$defineProperty2 = __webpack_require__(/*! @babel/runtime-corejs3/core-js-stable/object/define-property */ "./node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property.js");

_Object$defineProperty2(exports, "__esModule", {
  value: true
});

exports.default = void 0;

var _defineProperty = _interopRequireDefault(__webpack_require__(/*! ../../../../../../node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property */ "./node_modules/@babel/runtime-corejs3/core-js-stable/object/define-property.js"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; (0, _defineProperty.default)(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Util =
/*#__PURE__*/
function () {
  function Util() {
    _classCallCheck(this, Util);
  }

  _createClass(Util, null, [{
    key: "getBaseHref",
    value: function getBaseHref() {
      var base = document.getElementsByTagName('base')[0];

      if (base) {
        return base.href;
      }

      return '';
    }
  }, {
    key: "setLocation",
    value: function setLocation(url) {
      if (window && window.location) {
        window.location.href = Util.getBaseHref() + url;
      }
    }
  }, {
    key: "toggle",
    value: function toggle(booleanValue, elementName) {
      var checkboxes = document.getElementsByName(elementName);

      for (var index in checkboxes) {
        if (checkboxes.hasOwnProperty(index)) {
          checkboxes[index].checked = booleanValue;
        }
      }
    }
  }]);

  return Util;
}();

exports.default = Util;

/***/ })

},[["./src/main/assets/js/apps/search/index.js","vendor"]]]);
});
//# sourceMappingURL=search.js.map