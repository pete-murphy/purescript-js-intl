# Intl API Audit: ECMA-402 / MDN vs PureScript Bindings

This document compares the ECMAScript Internationalization API (ECMA-402) and MDN documentation surface to the PureScript bindings in this repository.

**Spec:** <https://tc39.es/ecma402/>  
**MDN:** <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl>

---

## 1. Top-level Intl

| Item | Spec | PureScript |
|------|------|------------|
| `getCanonicalLocales(locales)` | 8.3.1 | `JS.Intl.getCanonicalLocales` |
| `supportedValuesOf(key)` | 8.3.2 | `JS.Intl.supportedValuesOf` |

---

## 2. Intl.Collator

Constructor, `supportedLocalesOf`, `compare`, `resolvedOptions` — implemented in `JS.Intl.Collator`. Options: localeMatcher, usage, sensitivity, numeric, caseFirst, ignorePunctuation.

---

## 3. Intl.DateTimeFormat

Constructor, `supportedLocalesOf`, `format`, `formatRange`, `formatRangeToParts`, `formatToParts`, `resolvedOptions` — implemented. Verify all Table 16 options (dateStyle, timeStyle, timeZone, calendar, etc.).

---

## 4. Intl.DisplayNames

Constructor (options required), `supportedLocalesOf`, `of_`, `resolvedOptions` — implemented.

---

## 5. Intl.DurationFormat

Constructor, `supportedLocalesOf`, `format`, `formatToParts`, `resolvedOptions` — implemented. Verify per-unit options and fractionalDigits.

---

## 6. Intl.ListFormat

Constructor, `supportedLocalesOf`, `format`, `formatToParts`, `resolvedOptions` — implemented.

---

## 7. Intl.Locale

Constructor, getters (baseName, calendar, collation, firstDayOfWeek, hourCycle, language, numberingSystem, region, script), `maximize`, `minimize`.

**CHECK:** `variants`, `getCalendars()`, `getCollations()`, `getHourCycles()`, `getNumberingSystems()`, `getTimeZones()`, `getTextInfo()`, `getWeekInfo()`.

---

## 8. Intl.NumberFormat

Constructor, `supportedLocalesOf`, `format`, `formatRange`, `formatRangeToParts`, `formatToParts`, `resolvedOptions` — implemented.

**CHECK:** `roundingIncrement`, `roundingMode`, `roundingPriority`, `trailingZeroDisplay` in options and resolvedOptions.

---

## 9. Intl.PluralRules

Constructor, `supportedLocalesOf`, `select`, `selectRange`, `resolvedOptions` — implemented.

---

## 10. Intl.RelativeTimeFormat

Constructor, `supportedLocalesOf`, `format`, `formatToParts`, `resolvedOptions` — implemented.

---

## 11. Intl.Segmenter

Constructor, `supportedLocalesOf`, `segment`, `resolvedOptions` — implemented.

**CHECK:** Segments object — `containing(index)`, `[Symbol.iterator]()`, segment data (segment, index, input, isWordLike).

---

## 12. Locale-sensitive builtins (ECMA-402 §20)

- **String:** `localeCompare`, `toLocaleLowerCase`, `toLocaleUpperCase` — `JS.LocaleSensitive.String`
- **Number:** `toLocaleString` — `JS.LocaleSensitive.Number`
- **Date:** `toLocaleString`, `toLocaleDateString`, `toLocaleTimeString` — `JS.LocaleSensitive.Date`
- **CHECK:** `BigInt.prototype.toLocaleString`, `Array.prototype.toLocaleString`

---

After running `just download-docs`, use `docs/reference/mdn/` and `docs/reference/ecma402/spec.html` for detailed comparison.
