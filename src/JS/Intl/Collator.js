"use strict";

export function _new(locales, options) {
  return new Intl.Collator(locales, options);
}

export function _supportedLocalesOf(locales, options) {
  return Intl.Collator.supportedLocalesOf(locales, options);
}

export function _compare(collator, x, y) {
  return collator.compare(x, y);
}

export function _resolvedOptions(collator) {
  return collator.resolvedOptions();
}
