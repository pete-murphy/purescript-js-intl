"use strict";

export function _new(locales, options) {
  return new Intl.RelativeTimeFormat(locales, options);
}

export function _format(relativeTimeFormat, value, unit) {
  return relativeTimeFormat.format(value, unit);
}

export function _formatToParts(relativeTimeFormat, value, unit) {
  return relativeTimeFormat.formatToParts(value, unit);
}

export function _resolvedOptions(relativeTimeFormat) {
  return relativeTimeFormat.resolvedOptions();
}

export function _supportedLocalesOf(locales, options) {
  return Intl.RelativeTimeFormat.supportedLocalesOf(locales, options);
}
