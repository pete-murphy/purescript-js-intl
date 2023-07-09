"use strict";

export function _new(locales, options) {
  return new Intl.Segmenter(locales, options);
}

export function _resolvedOptions(segmenter) {
  return segmenter.resolvedOptions();
}

export function _supportedLocalesOf(locales, options) {
  return Intl.Segmenter.supportedLocalesOf(locales, options);
}

export function _segmentIterator(segmenter, string) {
  return segmenter.segment(string)[Symbol.iterator]();
}

export function _nextSegment(nothing, just, tuple, segments) {
  const next = segments.next();
  if (next.done) {
    return nothing;
  }
  return just(tuple(next.value, segments));
}
