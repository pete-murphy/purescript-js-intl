"use strict";

export function _new(locales, options) {
  return new Intl.PluralRules(locales, options);
}

export function _resolvedOptions(pluralRules) {
  return pluralRules.resolvedOptions();
}

export function _select(pluralRules, n) {
  return pluralRules.select(n);
}

export function _selectRange(pluralRules, n, n2) {
  return pluralRules.selectRange(n, n2);
}

export function _supportedLocalesOf(locales, options) {
  return Intl.PluralRules.supportedLocalesOf(locales, options);
}
