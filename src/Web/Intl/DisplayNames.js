"use strict";

export function _new(locales, options) {
  return new Intl.DisplayNames(locales, options);
}

export function _supportedLocalesOf(locales, options) {
  return Intl.DisplayNames.supportedLocalesOf(locales, options);
}

export function _of(displayNames, code) {
  return displayNames.of(code);
}
