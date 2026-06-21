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

  group('Git hooks', () {
    test(
      'pre-commit clears Git hook environment before Flutter analyze',
      () async {
        await expectHookClearsGitEnvironment(
          '.githooks/pre-commit',
          const ['analyze'],
        );
      },
    );

    test(
      'pre-push clears Git hook environment before Flutter commands',
      () async {
        await expectHookClearsGitEnvironment(
          '.githooks/pre-push',
          const ['analyze', 'test'],
        );
      },
    );
  });
}

Future<void> expectHookClearsGitEnvironment(
  String hookPath,
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
    expect(await fixture.flutterInvocations(), expectedFlutterCommands);
  } finally {
    await fixture.dispose();
  }
}

final class HookFixture {
  HookFixture._(this.root, this.tools, this.invocations);

  final Directory root;
  final Directory tools;
  final File invocations;

  static Future<HookFixture> create() async {
    final root = await Directory.systemTemp.createTemp('opendiet_hooks_test_');
    final tools = await Directory('${root.path}/tools').create();
    final invocations = File('${root.path}/flutter_invocations.txt');

    await _writeExecutable(
      File('${tools.path}/dart'),
      '''
#!/bin/sh
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

exit 0
''',
    );
    await _writeExecutable(
      File('${tools.path}/flutter'),
      r'''
#!/bin/sh
printf '%s\n' "$1" >> "$HOOK_INVOCATIONS"

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

    return HookFixture._(root, tools, invocations);
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
        'HOOK_INVOCATIONS': invocations.path,
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
        'HOOK_INVOCATIONS': invocations.path,
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

  Future<List<String>> flutterInvocations() async {
    if (!invocations.existsSync()) {
      return const [];
    }

    return invocations.readAsLines();
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
