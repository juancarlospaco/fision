import strutils, sequtils, algorithm, strformat

const
  url = "https://raw.githubusercontent.com/nim-lang/Nim/devel/testament/important_packages.nim"
  code = staticExec("curl " & url).strip.splitLines
  packages = block:
    var result: seq[string]
    for it in filterIt(code, (it.startsWith("pkg1 ") or it.startsWith("pkg2 ")) and (it.contains(", false") or not it.contains(", true"))):
      result.add "  " & it.toLowerAscii.split(", false" )[0].replace("pkg1 ", "").replace("pkg2 ", "")
    echo result.len
    result.sorted.join(",\n")

static:
  writeFile("fision.nimble", fmt"""
requires "nim >= { NimVersion }",
{packages}
# { CompileDate }T{ CompileTime }
version     = "{ CompileDate.replace("-", ".") }"
author      = "Juan Carlos"
description = "Official important_packages with 0 dependencies and all unittests passing"
license     = "MIT"
""")
