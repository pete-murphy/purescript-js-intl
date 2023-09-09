"use strict";

export function _new(tag, options) {
  return new Intl.Locale(tag, options);
}

export function _baseName(locale) {
  return locale.baseName;
}

export function _calendar(locale) {
  return locale.calendar;
}

export function _caseFirst(locale) {
  return locale.caseFirst;
}

export function _collation(locale) {
  return locale.collation;
}

export function _hourCycle(locale) {
  return locale.hourCycle;
}

export function _numeric(locale) {
  return locale.numeric;
}

export function _numberingSystem(locale) {
  return locale.numberingSystem;
}

export function _language(locale) {
  return locale.language;
}

export function _script(locale) {
  return locale.script;
}

export function _region(locale) {
  return locale.region;
}

export function _maximize(locale) {
  return locale.maximize();
}

export function _minimize(locale) {
  return locale.minimize();
}
