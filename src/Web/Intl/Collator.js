"use strict";

export function _new(locales, opts) {
  return new Intl.Collator(locales, opts);
}

export function _supportedLocalesOf(locales, opts) {
  return Intl.Collator.supportedLocalesOf(locales, opts);
}

export function _compare(collator, x, y) {
  return collator.compare(x, y);
}

export function _resolvedOptions(collator) {
  return collator.resolvedOptions();
}
