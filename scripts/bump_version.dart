#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'type',
      abbr: 't',
      allowed: ['major', 'minor', 'patch', 'build'],
      defaultsTo: 'patch',
      help: 'Version bump type',
    )
    ..addFlag('help', abbr: 'h', help: 'Show help');

  try {
    final results = parser.parse(arguments);

    if (results['help']) {
      print('Usage: dart scripts/bump_version.dart [options]');
      print('');
      print('Options:');
      print(parser.usage);
      print('');
      print('Examples:');
      print('  dart scripts/bump_version.dart -t patch   # 1.0.0 -> 1.0.1');
      print('  dart scripts/bump_version.dart -t minor   # 1.0.0 -> 1.1.0');
      print('  dart scripts/bump_version.dart -t major   # 1.0.0 -> 2.0.0');
      print('  dart scripts/bump_version.dart -t build   # 1.0.0+1 -> 1.0.0+2');
      return;
    }

    final type = results['type'] as String;
    bumpVersion(type);
  } catch (e) {
    print('Error: $e');
    print('Use --help for usage information');
    exit(1);
  }
}

void bumpVersion(String type) {
  print('Bumping $type version...');

  final result = Process.runSync('dart', [
    'pub',
    'global',
    'run',
    'cider',
    'bump',
    type,
  ]);

  if (result.exitCode == 0) {
    print('Version bumped successfully!');
    print(result.stdout);

    // Show current version
    final versionResult = Process.runSync('dart', [
      'pub',
      'global',
      'run',
      'cider',
      'version',
    ]);
    if (versionResult.exitCode == 0) {
      print('Current version: ${versionResult.stdout.toString().trim()}');
    }
  } else {
    print('Error bumping version:');
    print(result.stderr);
    exit(1);
  }
}
