"use strict";

export function _getCanonicalLocales(nothing, just, locales) {
  try {
    return just(Intl.getCanonicalLocales(locales));
  } catch (e) {
    return nothing;
  }
}

export function _supportedValuesOf(key) {
  return Intl.supportedValuesOf(key);
}
