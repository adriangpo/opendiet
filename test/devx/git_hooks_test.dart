import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
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
        'PATH': path,
      },
      includeParentEnvironment: false,
      workingDirectory: root.path,
    );
  }

  Future<List<String>> flutterInvocations() async {
    if (!invocations.existsSync()) {
      return const [];
    }

    return invocations.readAsLines();
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
