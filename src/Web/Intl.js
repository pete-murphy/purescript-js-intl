"use strict";

export function _getCanonicalLocales(locales) {
  return Intl.getCanonicalLocales(locales);
}

export function _supportedValuesOf(key) {
  return Intl.supportedValuesOf(key);
}
