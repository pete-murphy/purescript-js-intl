"use strict";

export function _getCanonicalLocales(just, nothing, locales) {
  try {
    return just(Intl.getCanonicalLocales(locales));
  } catch (e) {
    return nothing;
  }
}

export function _supportedValuesOf(key) {
  return Intl.supportedValuesOf(key);
}
