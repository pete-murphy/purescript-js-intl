"use strict";

export function _new(locales, opts) {
  return new Intl.RelativeTimeFormat(locales, opts);
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

export function _supportedLocalesOf(locales, opts) {
  return Intl.RelativeTimeFormat.supportedLocalesOf(locales, opts);
}
