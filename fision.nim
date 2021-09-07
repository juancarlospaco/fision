import std/[strutils, sequtils, algorithm, strformat]

const
  blockList = ["\"comprehension\"", "\"with\"", "\"kdtree\"", "\"snip\"", "\"tensordsl\"", "\"bigints\""]  # Packages flaky to install(?).
  url = "https://raw.githubusercontent.com/nim-lang/Nim/devel/testament/important_packages.nim"
  code = staticExec("curl " & url).strip.splitLines
  pkgs = filterIt(code, it.startsWith"pkg " and not it.contains"allowFailure")
  fltr = map(pkgs, proc(s: string): string = s.toLowerAscii.split(", ")[0].replace("pkg ", "").strip)
  packages = filterIt(fltr, it notin blockList and it.len > 0).sorted.join "\t,\n  "

static:
  echo packages
  writeFile("fision.nimble", fmt"""
requires "nim >= { NimVersion }",
  { packages }

version     = "{ CompileDate.replace("-", ".") }"
author      = "Juan_Carlos.nim"
description = "important_packages with 0 dependencies and all unittests passing"
license     = "MIT"
""")
