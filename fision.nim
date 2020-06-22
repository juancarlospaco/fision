import strutils, sequtils, algorithm, strformat

const
  blockList = ["comprehension", "with"] # Packages with problems to install of some kind.
  url = "https://raw.githubusercontent.com/nim-lang/Nim/devel/testament/important_packages.nim"
  code = staticExec("curl " & url).strip.splitLines

var packages = code
packages = filterIt(packages, (it.startsWith("pkg1 ") or it.startsWith("pkg2 ")) and (it.contains(", false") or not it.contains(", true")))
packages = mapIt(packages, it.toLowerAscii.split(", false" )[0].replace("pkg1 ", "").replace("pkg2 ", "").strip)
packages = filterIt(packages, it notin blockList).sorted
assert packages.len > 0

writeFile("fision.nimble", fmt"""
requires "nim >= { NimVersion }",
  { packages.join(",\n  ") }
#END { CompileDate }T{ CompileTime }

version     = "{ CompileDate.replace("-", ".") }"
author      = "Juan Carlos"
description = "important_packages with 0 dependencies and all unittests passing"
license     = "MIT"
""")
