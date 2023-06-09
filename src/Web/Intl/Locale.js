"use strict";

export function _new(tag, options) {
  return new Intl.Locale(tag, options);
}

export function _baseName(locale) {
  return locale.baseName;
}

export function _maximize(locale) {
  return locale.maximize();
}

export function _minimize(locale) {
  return locale.minimize();
}
