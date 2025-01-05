"use strict";

export function _new(locales, options) {
  return new Intl.DurationFormat(locales, options);
}

export function _format(durationFormat, number) {
  return durationFormat.format(number);
}

export function _formatToParts(durationFormat, number) {
  return durationFormat.formatToParts(number);
}

export function _resolvedOptions(durationFormat) {
  return durationFormat.resolvedOptions();
}

export function _supportedLocalesOf(locales, options) {
  return Intl.NumberFormat.supportedLocalesOf(locales, options);
}
