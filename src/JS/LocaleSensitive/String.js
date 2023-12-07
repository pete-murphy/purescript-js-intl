"use strict";

export function _localeCompare(locales, options, a, b) {
  return a.localeCompare(b, locales, options);
}

export function _toLocaleLowerCase(locales, string) {
  return string.toLocaleLowerCase(locales);
}

export function _toLocaleUpperCase(locales, string) {
  return string.toLocaleUpperCase(locales);
}
