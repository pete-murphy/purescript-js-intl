"use strict";

export function _new(locales, options) {
  return new Intl.ListFormat(locales, options);
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

export function _supportedLocalesOf(locales, options) {
  return Intl.ListFormat.supportedLocalesOf(locales, options);
}
