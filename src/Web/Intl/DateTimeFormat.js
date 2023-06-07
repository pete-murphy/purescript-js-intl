"use strict";

export function _new(locales, opts) {
  return new Intl.DateTimeFormat(locales, opts);
}

export function _supportedLocalesOf(locales, opts) {
  return Intl.DateTimeFormat.supportedLocalesOf(locales, opts);
}

export function _format(dateTimeFormat, date) {
  return dateTimeFormat.format(date);
}

export function _formatRange(dateTimeFormat, date1, date2) {
  return dateTimeFormat.formatRange(date1, date2);
}

export function _formatRangeToParts(dateTimeFormat, date1, date2) {
  return dateTimeFormat.formatRangeToParts(date1, date2);
}

export function _formatToParts(dateTimeFormat, date) {
  return dateTimeFormat.formatToParts(date);
}

export function _resolvedOptions(dateTimeFormat) {
  return dateTimeFormat.resolvedOptions();
}
