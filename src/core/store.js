/* global window */
import { applyMiddleware, compose } from 'redux';
import { createLogger } from 'redux-logger';
import config from 'config';


/*
 * Enhance a redux store with common middleware.
 *
 * This returns a function that takes a single argument, `createStore`,
 * and returns a new `createStore` function.
 */
export function middleware({
  _config = config, _createLogger = createLogger,
  _window = typeof window !== 'undefined' ? window : null,
  sagaMiddleware = null,
} = {}) {
  const isDev = _config.get('isDevelopment');

  const callbacks = [];
  if (isDev && !_config.get('server')) {
    // Log all Redux actions but only when in development
    // and only on the client side.
    callbacks.push(_createLogger());
  }
  if (sagaMiddleware) {
    callbacks.push(sagaMiddleware);
  }

  return compose(
    applyMiddleware(...callbacks),
    isDev && _window && _window.devToolsExtension ?
      _window.devToolsExtension() : (createStore) => createStore
  );
}
