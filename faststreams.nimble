mode = ScriptMode.Verbose

packageName   = "faststreams"
version       = "0.3.0"
author        = "Status Research & Development GmbH"
description   = "Nearly zero-overhead input/output streams for Nim"
license       = "Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 1.2.0",
         "stew",
         "testutils",
         "chronos",
         "unittest2"

### Helper functions
proc test(env, path: string) =
  # Compilation language is controlled by TEST_LANG
  var lang = "c"
  if existsEnv"TEST_LANG":
    lang = getEnv"TEST_LANG"

  let common_args = "-r -f --hints:off --skipParentCfg --styleCheck:usages --styleCheck:error"

  exec "nim " & lang & " " & env &
    " -d:async_backend=none " & common_args & " " & path
  exec "nim " & lang & " " & env &
    " -d:async_backend=chronos " & common_args & " " & path
  # TODO std backend is broken / untested
  # exec "nim " & lang & " " & env &
  #  " -d:async_backend=chronos " & common_args & " " & path

task test, "Run all tests":
  test "-d:debug   --threads:on", "tests/all_tests"
  test "-d:release --threads:on", "tests/all_tests"
  test "-d:danger  --threads:on", "tests/all_tests"
