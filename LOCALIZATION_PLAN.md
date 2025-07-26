# SavvyCart Localization Implementation Plan

## Overview
This plan outlines the technical implementation of internationalization (i18n) for SavvyCart, supporting English, Spanish, Russian, and Portuguese with English as the fallback language.

## Current State
- **Status**: Phase 2 Complete - Ready for Phase 3 (Code Migration)
- **Next Action**: Begin systematic replacement of hardcoded strings with localized versions
- **Supported Languages**: English (infrastructure ready for es, ru, pt)
- **Target Languages**: English (en), Spanish (es), Russian (ru), Portuguese (pt)
- **Localization Infrastructure**: ✅ Complete
- **String Audit**: ✅ Complete (183+ strings identified)
- **ARB Template**: ✅ Complete (app_en.arb created)
- **Generated Classes**: ✅ Complete (AppLocalizations available)

## Technical Architecture

### Dependencies Required
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

### File Structure
```
lib/
├── l10n/
│   ├── app_en.arb (English - template) ✅ CREATED
│   ├── app_localizations.dart (auto-generated) ✅ GENERATED
│   ├── app_localizations_en.dart (auto-generated) ✅ GENERATED
│   ├── app_es.arb (Spanish) - pending
│   ├── app_ru.arb (Russian) - pending
│   └── app_pt.arb (Portuguese) - pending
└── main.dart ✅ CONFIGURED
l10n.yaml (configuration file) ✅ CREATED
```

## Implementation Phases

### ✅ Phase 1: Foundation Setup (COMPLETED)
**Objective**: Establish the localization infrastructure

#### Tasks:
1. **✅ Add Dependencies**
   - ✅ Added `flutter_localizations` to `pubspec.yaml` (intl was already present)
   - ✅ Enabled `generate: true` in flutter section

2. **✅ Create l10n Configuration**
   - ✅ Created `l10n.yaml` in project root with correct configuration

3. **✅ Configure MaterialApp**
   - ✅ Updated `main.dart` with localization delegates
   - ✅ Set supported locales: `en`, `es`, `ru`, `pt`
   - ✅ Configured locale resolution with English fallback

### ✅ Phase 2: String Extraction and Template Creation (COMPLETED)
**Objective**: Identify and extract all user-facing strings

#### Tasks:
1. **✅ Audit Existing Strings**
   - ✅ Comprehensive scan of all Dart files completed
   - ✅ Identified 183+ hardcoded user-facing strings including:
     - UI labels and buttons (50+ strings)
     - Error messages (25+ strings)
     - Navigation titles (15+ strings)
     - Form hints and validation messages (20+ strings)
     - Dialog content (30+ strings)
     - Settings and configuration text (25+ strings)
     - Empty states and help text (18+ strings)

2. **✅ Create English Template**
   - ✅ Created `lib/l10n/app_en.arb` with all identified string``s
   - ✅ Used semantic keys (e.g., `appTitle`, `createShoppingList`, `errorLoadingSearchResults`)
   - ✅ Included comprehensive metadata and descriptions for translators
   - ✅ Properly handled parameterized strings (e.g., `chatWithList`, `failedToRemoveItem`)

3. **✅ Generate Base Localization**
   - ✅ Successfully ran `flutter gen-l10n` to generate `AppLocalizations` class
   - ✅ Generated files: `app_localizations.dart` and `app_localizations_en.dart`
   - ✅ Verified all strings are available as methods in the generated classes

### ✅ Phase 3: Code Migration (COMPLETED)
**Objective**: Replace hardcoded strings with localized versions

#### Tasks:
1. **✅ Update Import Statements**
   - ✅ Added `import 'l10n/app_localizations.dart';` where needed (note: generated in lib/l10n/, not flutter_gen)

2. **✅ Replace Hardcoded Strings**
   - ✅ Systematically replaced strings with `AppLocalizations.of(context).keyName`
   - ✅ Handled context-less scenarios with proper context passing
   - ✅ Updated all widget files progressively (183+ string replacements)
   - ✅ Priority order: main screens → dialogs → forms → error messages

3. **✅ Handle Special Cases**
   - ✅ DateTime formatting with locale-specific patterns
   - ✅ Number formatting (currency, decimals)
   - ✅ Pluralization rules for countable items
   - ✅ Parametrized strings (already prepared in ARB file)

### Phase 4: Translation Creation
**Objective**: Create translation files for target languages

#### Tasks:
1. **Create ARB Files**
   - Copy `app_en.arb` structure to create:
     - `app_es.arb` (Spanish)
     - `app_ru.arb` (Russian)
     - `app_pt.arb` (Portuguese)

2. **Initial Translations**
   - Translate all strings for each target language
   - Ensure proper handling of special characters
   - Consider cultural context for translations

3. **Validation**
   - Test all languages render correctly
   - Verify RTL support if needed (Russian uses LTR)
   - Check text overflow and UI layout adjustments

### Phase 5: Advanced Features
**Objective**: Implement advanced localization features

#### Tasks:
1. **Locale-Specific Formatting**
   - Currency formatting per locale
   - Date/time formatting
   - Number formatting (decimal separators)

2. **Dynamic Locale Switching**
   - Add language selection in settings
   - Implement locale persistence
   - Hot-reload locale changes

3. **Accessibility Support**
   - Screen reader compatibility
   - Semantic labels translation

## Technical Implementation Details

### Locale Resolution Strategy
```dart
localeResolutionCallback: (locale, supportedLocales) {
  // Check if current locale is supported
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale?.languageCode) {
      return supportedLocale;
    }
  }
  // Fallback to English
  return const Locale('en');
}
```

### ARB File Structure Example
```json
{
  "@@locale": "en",
  "appTitle": "SavvyCart",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome to SavvyCart!",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen"
  }
}
```

### Context-less Translation Helper
```dart
class LocalizationHelper {
  static String getString(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context);
    // Dynamic key access implementation
  }
}
```

## Quality Assurance

### Validation Checklist
- [ ] All user-facing strings are externalized
- [ ] No hardcoded strings remain in UI code
- [ ] All target languages load correctly
- [ ] Fallback to English works properly
- [ ] UI layouts accommodate different text lengths
- [ ] Special characters display correctly
- [ ] Currency and date formatting is locale-appropriate

## Migration Strategy

### Rollout Approach
1. **Development**: Implement on feature branch
2. **Testing**: Comprehensive testing with all locales
3. **Staging**: Deploy with limited user testing
4. **Production**: Gradual rollout with monitoring

### Risk Mitigation
- Keep English as primary development language
- Maintain backward compatibility during migration
- Implement comprehensive error handling for missing translations
- Create translation key audit tools

---

## Status Tracking

### Current Phase: Phase 4 - Translation Creation
- **Completed**: 
  - ✅ Phase 1: Foundation Setup (dependencies, configuration, MaterialApp setup)
  - ✅ Phase 2: String Extraction and Template Creation (183+ strings audited, ARB template created, classes generated)
  - ✅ Phase 3: Code Migration (all hardcoded strings replaced with localized versions)
- **Next Action**: Create translation files for Spanish, Russian, and Portuguese
- **Blockers**: None identified
- **Notes**: 
  - All hardcoded strings have been successfully replaced with AppLocalizations calls
  - 183+ string replacements completed across all widget files
  - Application now fully supports localization infrastructure
  - Ready to create target language ARB files

### Implementation Progress
- **Phase 1**: ✅ 100% Complete
- **Phase 2**: ✅ 100% Complete  
- **Phase 3**: ✅ 100% Complete
- **Phase 4**: 🔄 0% Complete (Ready to begin)
- **Phase 5**: ⏳ Pending (Advanced features)