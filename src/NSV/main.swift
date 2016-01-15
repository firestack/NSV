import Foundation

import NASA

// print("PROG_NAME = \(Process.arguments[0])")
// print("ARGC = \(Process.argc)")
// print("ARGV = \(Process.arguments)")
// for path in Glob(pattern:Process.arguments[1]+"**/*"){
// 	//print(path)
// }
//print(FileUtil.FindFileFromPath(Process.arguments[1], fileName:"index.tab"))

NASA.rootStore = Process.arguments[1]
let MGSL = Index(pathRoot:Process.arguments[1])

let results = MGSL.query([SearchQuery(3, "MEDIAN_TOPOGRAPHY"), SearchQuery(12, "720")])



REPL().loop()
