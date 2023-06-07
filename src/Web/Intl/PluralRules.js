"use strict";

export function _new(locales, opts) {
  return new Intl.PluralRules(locales, opts);
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

export function _supportedLocalesOf(locales, opts) {
  return Intl.PluralRules.supportedLocalesOf(locales, opts);
}
