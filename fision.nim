import strutils, sequtils, algorithm, strformat

static:
  const
    blockList = ["comprehension", "with"] # Packages with problems to install of some kind.
    url = "https://raw.githubusercontent.com/nim-lang/Nim/devel/testament/important_packages.nim"
    code = staticExec("curl " & url).strip.splitLines
    filter0 = filterIt(code, (it.startsWith("pkg1 ") or it.startsWith("pkg2 ")) and (it.contains(", false") or not it.contains(", true")))
    filter1 = map(filter0, proc(s: string): string = s.toLowerAscii.split(", false" )[0].replace("pkg1 ", "").replace("pkg2 ", "").strip)
    packages = filterIt(filter1, it notin blockList).sorted.join(",\n  ")
  writeFile("fision.nimble", fmt"""
requires "nim >= { NimVersion }",
  {packages}
#END { CompileDate }T{ CompileTime }

version     = "{ CompileDate.replace("-", ".") }"
author      = "Juan Carlos"
description = "important_packages with 0 dependencies and all unittests passing"
license     = "MIT"
""")
