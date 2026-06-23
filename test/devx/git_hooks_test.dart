import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flutter wrapper', () {
    test(
      'clears Git environment and locks Flutter SDK access',
      () async {
        final fixture = await HookFixture.create();

        try {
          final result = await fixture.runFlutterWrapper(const ['analyze']);

          expect(
            result.exitCode,
            0,
            reason: [
              'stdout:',
              result.stdout as String,
              'stderr:',
              result.stderr as String,
            ].join('\n'),
          );
          expect(await fixture.flutterInvocations(), const ['analyze']);
          expect(await fixture.lockStates(), const ['locked']);
        } finally {
          await fixture.dispose();
        }
      },
    );

    test('removes stale SDK locks before running Flutter', () async {
      final fixture = await HookFixture.create();

      try {
        await fixture.createStaleFlutterLock();

        final result = await fixture.runFlutterWrapper(const ['analyze']);

        expect(
          result.exitCode,
          0,
          reason: [
            'stdout:',
            result.stdout as String,
            'stderr:',
            result.stderr as String,
          ].join('\n'),
        );
        expect(await fixture.flutterInvocations(), const ['analyze']);
        expect(await fixture.lockStates(), const ['locked']);
      } finally {
        await fixture.dispose();
      }
    });
  });

  group('Dart wrapper', () {
    test(
      'clears Git environment and locks SDK access',
      () async {
        final fixture = await HookFixture.create();

        try {
          final result = await fixture.runDartWrapper(const [
            'run',
            'build_runner',
          ]);

          expect(
            result.exitCode,
            0,
            reason: [
              'stdout:',
              result.stdout as String,
              'stderr:',
              result.stderr as String,
            ].join('\n'),
          );
          expect(await fixture.dartInvocations(), const ['run build_runner']);
          expect(await fixture.lockStates(), const ['locked']);
        } finally {
          await fixture.dispose();
        }
      },
    );
  });

  group('Git hooks', () {
    test(
      'pre-commit clears Git hook environment before Flutter analyze',
      () async {
        await expectHookClearsGitEnvironment(
          '.githooks/pre-commit',
          const ['format --output=none .'],
          const ['analyze'],
        );
      },
    );

    test(
      'pre-push clears Git hook environment before Flutter commands',
      () async {
        await expectHookClearsGitEnvironment(
          '.githooks/pre-push',
          const ['format --output=none --set-exit-if-changed .'],
          const ['analyze', 'test'],
        );
      },
    );

    test('pre-push remembers successful tree checks', () async {
      final fixture = await HookFixture.create();

      try {
        final result = await fixture.runHook('.githooks/pre-push');

        expect(
          result.exitCode,
          0,
          reason: [
            'stdout:',
            result.stdout as String,
            'stderr:',
            result.stderr as String,
          ].join('\n'),
        );
        expect(await fixture.cachedPrePushTree(), fixture.treeHash);
      } finally {
        await fixture.dispose();
      }
    });

    test(
      'pre-push skips checks when the current tree already passed',
      () async {
        final fixture = await HookFixture.create();

        try {
          await fixture.cachePrePushTree(fixture.treeHash);

          final result = await fixture.runHook('.githooks/pre-push');

          expect(
            result.exitCode,
            0,
            reason: [
              'stdout:',
              result.stdout as String,
              'stderr:',
              result.stderr as String,
            ].join('\n'),
          );
          expect(await fixture.dartInvocations(), isEmpty);
          expect(await fixture.flutterInvocations(), isEmpty);
        } finally {
          await fixture.dispose();
        }
      },
    );
  });
}

Future<void> expectHookClearsGitEnvironment(
  String hookPath,
  List<String> expectedDartCommands,
  List<String> expectedFlutterCommands,
) async {
  final fixture = await HookFixture.create();

  try {
    final result = await fixture.runHook(hookPath);

    expect(
      result.exitCode,
      0,
      reason: [
        'stdout:',
        result.stdout as String,
        'stderr:',
        result.stderr as String,
      ].join('\n'),
    );
    expect(await fixture.dartInvocations(), expectedDartCommands);
    expect(await fixture.flutterInvocations(), expectedFlutterCommands);
  } finally {
    await fixture.dispose();
  }
}

final class HookFixture {
  HookFixture._(this.root, this.tools, this.dartCalls, this.flutterCalls);

  final Directory root;
  final Directory tools;
  final File dartCalls;
  final File flutterCalls;

  final String treeHash = 'tree-for-current-commit';

  static Future<HookFixture> create() async {
    final root = await Directory.systemTemp.createTemp('opendiet_hooks_test_');
    final tools = await Directory('${root.path}/tools').create();
    final dartCalls = File('${root.path}/dart_invocations.txt');
    final flutterCalls = File('${root.path}/flutter_invocations.txt');

    await _writeExecutable(
      File('${tools.path}/dart'),
      r'''
#!/bin/sh
printf '%s\n' "$*" >> "$DART_INVOCATIONS"

if [ "${GIT_DIR+x}" = x ] || [ "${GIT_WORK_TREE+x}" = x ] || [ "${GIT_INDEX_FILE+x}" = x ]; then
  echo "Git hook environment leaked into dart" >&2
  exit 41
fi

if [ -n "$OPENDIET_DART_LOCK_DIR" ] && [ -d "$OPENDIET_DART_LOCK_DIR" ]; then
  printf '%s\n' locked >> "$LOCK_STATES"
else
  echo "Dart SDK lock was not held" >&2
  exit 44
fi

exit 0
''',
    );
    await _writeExecutable(
      File('${tools.path}/git'),
      r'''
#!/bin/sh
if [ "$1" = "rev-parse" ] && [ "$2" = "--local-env-vars" ]; then
  printf '%s\n' GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
  exit 0
fi

if [ "$1" = "rev-parse" ] && [ "$2" = "--git-dir" ]; then
  printf '%s\n' "$FAKE_GIT_DIR"
  exit 0
fi

if [ "$1" = "rev-parse" ] && [ "$2" = "HEAD^{tree}" ]; then
  printf '%s\n' "$FAKE_TREE_HASH"
  exit 0
fi

exit 0
''',
    );
    await _writeExecutable(
      File('${tools.path}/flutter'),
      r'''
#!/bin/sh
printf '%s\n' "$*" >> "$FLUTTER_INVOCATIONS"

if [ "${GIT_DIR+x}" = x ] || [ "${GIT_WORK_TREE+x}" = x ] || [ "${GIT_INDEX_FILE+x}" = x ]; then
  echo "Git hook environment leaked into flutter" >&2
  exit 42
fi

if [ -n "$OPENDIET_FLUTTER_LOCK_DIR" ] && [ -d "$OPENDIET_FLUTTER_LOCK_DIR" ]; then
  printf '%s\n' locked >> "$LOCK_STATES"
else
  echo "Flutter SDK lock was not held" >&2
  exit 43
fi

exit 0
''',
    );

    return HookFixture._(root, tools, dartCalls, flutterCalls);
  }

  Future<ProcessResult> runHook(String hookPath) {
    final repositoryRoot = Directory.current.path;
    final path = [tools.path, '/usr/bin', '/bin'].join(':');

    return Process.run(
      '/usr/bin/sh',
      ['$repositoryRoot/$hookPath'],
      environment: <String, String>{
        'GIT_DIR': '$repositoryRoot/.git/worktrees/opendiet-precommit',
        'GIT_WORK_TREE': repositoryRoot,
        'GIT_INDEX_FILE': '$repositoryRoot/.git/index',
        'DART_INVOCATIONS': dartCalls.path,
        'FAKE_GIT_DIR': '${root.path}/git',
        'FAKE_TREE_HASH': treeHash,
        'FLUTTER_INVOCATIONS': flutterCalls.path,
        'LOCK_STATES': '${root.path}/lock_states.txt',
        'PATH': path,
        'TMPDIR': root.path,
      },
      includeParentEnvironment: false,
      workingDirectory: root.path,
    );
  }

  Future<ProcessResult> runFlutterWrapper(List<String> arguments) {
    final repositoryRoot = Directory.current.path;
    final path = [tools.path, '/usr/bin', '/bin'].join(':');

    return Process.run(
      '/usr/bin/sh',
      ['$repositoryRoot/tool/flutter_safe', ...arguments],
      environment: <String, String>{
        'FLUTTER_ROOT': '${root.path}/flutter_sdk',
        'GIT_DIR': '$repositoryRoot/.git/worktrees/opendiet-wrapper',
        'GIT_WORK_TREE': repositoryRoot,
        'GIT_INDEX_FILE': '$repositoryRoot/.git/index',
        'DART_INVOCATIONS': dartCalls.path,
        'FLUTTER_INVOCATIONS': flutterCalls.path,
        'LOCK_STATES': '${root.path}/lock_states.txt',
        'PATH': path,
        'TMPDIR': root.path,
      },
      includeParentEnvironment: false,
      workingDirectory: root.path,
    );
  }

  Future<ProcessResult> runDartWrapper(List<String> arguments) {
    final repositoryRoot = Directory.current.path;
    final path = [tools.path, '/usr/bin', '/bin'].join(':');

    return Process.run(
      '/usr/bin/sh',
      ['$repositoryRoot/tool/dart_safe', ...arguments],
      environment: <String, String>{
        'FLUTTER_ROOT': '${root.path}/flutter_sdk',
        'GIT_DIR': '$repositoryRoot/.git/worktrees/opendiet-wrapper',
        'GIT_WORK_TREE': repositoryRoot,
        'GIT_INDEX_FILE': '$repositoryRoot/.git/index',
        'DART_INVOCATIONS': dartCalls.path,
        'FLUTTER_INVOCATIONS': flutterCalls.path,
        'LOCK_STATES': '${root.path}/lock_states.txt',
        'PATH': path,
        'TMPDIR': root.path,
      },
      includeParentEnvironment: false,
      workingDirectory: root.path,
    );
  }

  Future<void> createStaleFlutterLock() async {
    final flutterRoot = '${root.path}/flutter_sdk';
    final lockName = flutterRoot.replaceAll(RegExp('[^A-Za-z0-9._-]'), '_');
    final lock = await Directory(
      '${root.path}/opendiet-flutter-locks/$lockName.lock',
    ).create(recursive: true);

    await File('${lock.path}/pid').writeAsString('999999');
  }

  Future<void> cachePrePushTree(String tree) async {
    await File(
      '${root.path}/git/opendiet/pre-push-passed-tree',
    ).create(recursive: true);
    await File(
      '${root.path}/git/opendiet/pre-push-passed-tree',
    ).writeAsString('$tree\n');
  }

  Future<String> cachedPrePushTree() async {
    final cache = File('${root.path}/git/opendiet/pre-push-passed-tree');
    return (await cache.readAsString()).trim();
  }

  Future<List<String>> dartInvocations() async {
    if (!dartCalls.existsSync()) {
      return const [];
    }

    return dartCalls.readAsLines();
  }

  Future<List<String>> flutterInvocations() async {
    if (!flutterCalls.existsSync()) {
      return const [];
    }

    return flutterCalls.readAsLines();
  }

  Future<List<String>> lockStates() async {
    final states = File('${root.path}/lock_states.txt');
    if (!states.existsSync()) {
      return const [];
    }

    return states.readAsLines();
  }

  Future<void> dispose() => root.delete(recursive: true);

  static Future<void> _writeExecutable(File file, String contents) async {
    await file.writeAsString(contents);
    final result = await Process.run('chmod', ['755', file.path]);
    if (result.exitCode != 0) {
      throw StateError(result.stderr as String);
    }
  }
}
