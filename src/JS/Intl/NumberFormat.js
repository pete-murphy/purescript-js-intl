"use strict";

export function _new(locales, options) {
  return new Intl.NumberFormat(locales, options);
}

export function _format(numberFormat, number) {
  return numberFormat.format(number);
}

export function _formatToParts(numberFormat, number) {
  return numberFormat.formatToParts(number);
}

export function _formatRange(numberFormat, number1, number2) {
  return numberFormat.formatRange(number1, number2);
}

export function _formatRangeToParts(numberFormat, number1, number2) {
  return numberFormat.formatRangeToParts(number1, number2);
}

export function _resolvedOptions(numberFormat) {
  return numberFormat.resolvedOptions();
}

export function _supportedLocalesOf(locales, options) {
  return Intl.NumberFormat.supportedLocalesOf(locales, options);
}
