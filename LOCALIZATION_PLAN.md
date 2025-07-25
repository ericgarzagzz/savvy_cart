# SavvyCart Localization Implementation Plan

## Overview
This plan outlines the technical implementation of internationalization (i18n) for SavvyCart, supporting English, Spanish, Russian, and Portuguese with English as the fallback language.

## Current State
- **Status**: Planning Phase
- **Next Action**: Analyze existing codebase for hardcoded strings
- **Supported Languages**: None (hardcoded English)
- **Target Languages**: English (en), Spanish (es), Russian (ru), Portuguese (pt)

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
│   ├── app_en.arb (English - template)
│   ├── app_es.arb (Spanish)
│   ├── app_ru.arb (Russian)
│   └── app_pt.arb (Portuguese)
├── generated/
│   └── l10n/
│       └── app_localizations.dart (auto-generated)
└── main.dart
l10n.yaml (configuration file)
```

## Implementation Phases

### Phase 1: Foundation Setup
**Objective**: Establish the localization infrastructure

#### Tasks:
1. **Add Dependencies**
   - Add `flutter_localizations` and `intl` to `pubspec.yaml`
   - Enable `generate: true` in flutter section

2. **Create l10n Configuration**
   - Create `l10n.yaml` in project root:
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   nullable-getter: false
   ```

3. **Configure MaterialApp**
   - Update `main.dart` to include localization delegates
   - Set supported locales: `en`, `es`, `ru`, `pt`
   - Configure locale resolution with English fallback

### Phase 2: String Extraction and Template Creation
**Objective**: Identify and extract all user-facing strings

#### Tasks:
1. **Audit Existing Strings**
   - Scan all Dart files for hardcoded user-facing strings
   - Identify strings in:
     - UI labels and buttons
     - Error messages
     - Navigation titles
     - Form hints and validation messages
     - Dialog content

2. **Create English Template**
   - Create `lib/l10n/app_en.arb` with all identified strings
   - Use semantic keys (e.g., `loginButton`, `errorInvalidEmail`)
   - Include metadata for translators

3. **Generate Base Localization**
   - Run `flutter gen-l10n` to generate `AppLocalizations` class
   - Verify generation works correctly

### Phase 3: Code Migration
**Objective**: Replace hardcoded strings with localized versions

#### Tasks:
1. **Update Import Statements**
   - Add `import 'package:flutter_gen/gen_l10n/app_localizations.dart';` where needed

2. **Replace Hardcoded Strings**
   - Systematically replace strings with `AppLocalizations.of(context)!.keyName`
   - Handle context-less scenarios with proper context passing
   - Update all widget files progressively

3. **Handle Special Cases**
   - DateTime formatting
   - Number formatting
   - Pluralization rules
   - Parametrized strings

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
    final localizations = AppLocalizations.of(context)!;
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

### Current Phase: Planning
- **Completed**: Documentation and planning
- **Next Action**: Add dependencies to pubspec.yaml
- **Blockers**: None identified
- **Notes**: Ready to begin Phase 1 implementation