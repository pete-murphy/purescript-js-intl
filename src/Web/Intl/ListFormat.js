"use strict";

export function _new(locales, opts) {
  return new Intl.ListFormat(locales, opts);
}

export function _format(listFormat, value, unit) {
  return listFormat.format(value, unit);
}

export function _formatToParts(listFormat, value, unit) {
  return listFormat.formatToParts(value, unit);
}

export function _resolvedOptions(listFormat) {
  return listFormat.resolvedOptions();
}

export function _supportedLocalesOf(locales, opts) {
  return Intl.ListFormat.supportedLocalesOf(locales, opts);
}
