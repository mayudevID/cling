# UI Consistency Refactor

## Existing visual language

The established Cling screens use a near-black `#101010` background, white primary text, muted white supporting text, and `#F599DA` for primary actions and selected states. Cabinet Grotesk is the product typeface. Shared buttons are 57 px high with 10 px corners; common cards and controls use dark gray surfaces and roughly 10–13 px corners. Screen content generally has 20 px horizontal padding. Newer financial screens already used the palette, but Material defaults left typography, inputs, dialogs, and buttons inconsistent.

## Reused and introduced components

- Existing `PinkButton`, `BlackButton`, and money formatting conventions remain in use where they fit. The transaction and goal screens remain the visual reference.
- Added `FinancialFeatureTheme`, a small local theme for the wallet, planning, and intelligence flows. It applies Cabinet Grotesk, Cling colors, rounded dark cards and dialogs, dark filled fields, readable focus/error borders, and appropriately sized buttons without changing unrelated application screens.
- Added `FinancialWalletSelector` and reused it in both add and edit transaction forms; long names stay within the field and both forms keep their existing BLoC selection behavior.
- Wallet cards now use a compact summary panel, wrapped status chips, flexible names and amounts, and an explicit default/active/archived treatment.

## Screens updated

- Wallets: responsive balance and wallet cards, localized add/edit and transfer forms, a useful empty state with an available create action, load retry, and confirmation before archiving.
- Add/edit income and expense forms: wallet selector field styling and long-name handling.
- Financial planning: overview, recurring expense, bills/reminders, runway, and settings screens use the shared local theme, including their Material forms and dialogs.
- Cling Check: emphasized purchase input and assessment result, semantic result border, and values that wrap or truncate safely on narrow screens.
- Cling Insights and detail: shared typography, dark cards, controls, and page chrome.
- Smart Savings Goals: shared forms and cards, with feasibility colored by its existing status and no changes to projection or saving behavior.

## Important UI decisions

- The theme is scoped to these financial feature routes so legacy screens retain their existing visual treatment.
- Wallet archive confirmation protects against accidental destructive actions; archived balances and history remain visible as before.
- The wallet screen continues to use the repository's existing transfer operation. No transfer-history screen was present in this UI, so none was added as part of this presentation refactor.
- Goal contribution inputs and outputs remain simulations until the existing explicit save action is used. No financial calculations, thresholds, persistence, or schemas were changed.
- Long translated wallet names and currency values are constrained with wrapping, flexible rows, and ellipsis; forms remain scrollable when the keyboard is open.

## Localization

Added English and Indonesian labels for wallet management, types, transfer directions, archive confirmation, status, empty/error states, wallet count, and the insight category fallback. Existing keys were retained. Phase 2 and Phase 3 screens continue to use their existing generated localization keys.

## Validation

- `fvm flutter gen-l10n` completed after granting the command access to the FVM SDK cache.
- `fvm dart format` completed for all changed Dart files.
- `fvm flutter analyze` passed with no issues.
- `fvm flutter test` passed all 61 tests, including 320 px wide theme and wallet-selector widget tests.
- No Android/iOS device rendering or screenshot review was performed.

## Remaining visual limitations

- The wallet screen has no transfer-history presentation in the existing route; this change preserves scope and does not introduce a new history flow.
- Other application screens outside these financial routes retain their existing typography and styling.
- Device-level small-screen, keyboard, and visual checks remain necessary to confirm native rendering on Android and iOS.
