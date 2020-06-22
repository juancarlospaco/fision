import strutils, sequtils, algorithm, strformat

const
  blockList = ["\"comprehension\"", "\"with\"", "\"kdtree\""]  # Packages flaky to install.
  url = "https://raw.githubusercontent.com/nim-lang/Nim/devel/testament/important_packages.nim"
  code = staticExec("curl " & url).strip.splitLines
  pkgs = filterIt(code, (it.startsWith("pkg1 ") or it.startsWith("pkg2 ")) and (it.contains(", false") or not it.contains(", true")))
  fltr = map(pkgs, proc(s: string): string = s.toLowerAscii.split(", false" )[0].replace("pkg1 ", "").replace("pkg2 ", "").strip)
  packages = filterIt(fltr, it notin blockList).sorted.join(",\n  ")

static:
  echo packages, "\n", packages.len
  writeFile("fision.nimble", fmt"""
requires "nim >= { NimVersion }",
  { packages }
#END { CompileDate }T{ CompileTime }

version     = "{ CompileDate.replace("-", ".") }"
author      = "Juan Carlos"
description = "important_packages with 0 dependencies and all unittests passing"
license     = "MIT"
""")
