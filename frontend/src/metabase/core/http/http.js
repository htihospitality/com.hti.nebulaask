/*
 * Created by Paul Engelke on 19 November 2021.
 */

import axios from "axios";
import qs from "qs";
import lodash from "lodash";
import cookie from "cookie";

/**
 * A utility class for providing HTTP request functionality.
 */
export default class Http {
  /**
   * A set of HTTP methods for requests made using {@link #request}.
   * @return {{DELETE: string, POST: string, GET: string, PUT: string}}
   * @constructor
   */
  static get Method() {
    return {
      GET: "get",
      POST: "post",
      PUT: "put",
      DELETE: "delete",
    };
  }

  /**
   * Initiates an HTTP request.
   *
   * @param {Object} config The request configuration.
   * @param {string} config.method The HTTP method to use for the request.
   * @param {string} config.url The url for the request. Unless absolute, then
   * the base url will be prepended.
   * @param {Object} [config.data] The data to send to the server as the
   * request payload.
   * @param {Object} [config.params] Any parameters that should be included in
   * the request URL.
   * @param {Object} [config.headers] Any HTTP headers that should be included
   * in the request.
   * @param {*} [config.cancelToken] A token that can be used to cancel the
   * request. This does not abort the server-side process but causes the
   * request promise to reject. Only use this to cancel fetch requests.
   * @param {string} [config.baseUrl] The base URL to be prepended to
   * `config.url`. This is optional and will be set to the primary server URL
   * by default.
   * @return {Promise}
   * @see https://github.com/axios/axios#request-config
   */
  static request(config) {
    const _config = lodash.merge(
      {
        baseURL: this._getBaseUrl(),
        timeout: this._getTimeout(),
        paramsSerializer: this._getParamsSerializer,
        withCredentials: true,
      },
      config,
    );

    return axios(_config);
  }

  /**
   * Gets the default transformer serializing URL parameters for HTTP requests.
   * @param {*} params The URL parameters to transform.
   * @return {string}
   * @private
   */
  static _getParamsSerializer(params) {
    return qs.stringify(params, { arrayFormat: "repeat" });
  }

  /**
   * Gets the default base URL for HTTP requests.
   * @return {string}
   * @public
   */
  static _getBaseUrl() {
    return null;
  }

  /**
   * Gets the default timeout threshold for HTTP requests.
   * @return {number}
   * @private
   */
  static _getTimeout() {
    // todo base this on the node environment deployment variable.
    return 12000; // ms
  }

  /**
   * Sets the authentication token in a cookie.
   * @param {string|null} token The authentication token to be used for
   * requests, or null if the token is being unset.
   * @public
   */
  static setToken(token) {
    document.cookie = cookie.serialize("hti-session", token, {
      maxAge: token
        ? 24 * 60 * 60 // Expire in 1 day, or
        : 0, // expire immediately.
      sameSite: "lax",
    });
  }

  /**
   * Acquires a cancellation token source, whose token can be set in a
   * request's configuration.
   *
   * Calling `source.cancel()` will cause the request to terminate and
   * throw an error that must be handled by one the promise chain's
   * `.catch()` handlers.
   *
   * @return {*}
   * @public
   */
  static getCancelToken() {
    return axios.CancelToken.source();
  }

  /**
   * Checks if the given error indicates that the request was cancelled on the
   * client.
   * @param {AppError} e The error that was thrown in the request promise
   * chain.
   * @return {boolean}
   * @public
   */
  static isCancelled(e) {
    return axios.isCancel(e);
  }
}
