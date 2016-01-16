//
//  Glob.swift
//
//  Created by Brad Grzesiak on 6/25/15.
//  Copyright © 2015 Bendyworks Inc.
//  Released under the Apache v2 License.
//

import Foundation
import Glibc

public class Glob: CollectionType {
    private var globFlags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
    var paths = [String]()

    public var startIndex: Int {
        return paths.startIndex
    }

    public var endIndex: Int {
        return paths.endIndex
    }

    public subscript(i: Int) -> String {
        return paths[i]
    }

    public init(pattern: String) {
        var gt = glob_t()
		defer{
			globfree(&gt)
		}

        if let cPatt = cPattern(pattern) {
            if executeGlob(cPatt, gt: &gt) {
                populateFiles(gt)
            }
        }
    }

    private func executeGlob(pattern: [CChar], gt: UnsafeMutablePointer<glob_t>) -> Bool {
        return 0 == glob(pattern, globFlags, nil, gt)
    }

    private func cPattern(pattern: String) -> [CChar]? {
        return pattern.cStringUsingEncoding(NSUTF8StringEncoding)
    }

    private func populateFiles(gt: glob_t) {
		for i in 0..<gt.gl_pathc{
			if let path = String.fromCString(gt.gl_pathv[Int(i)]) {
				paths.append(path)
			}
		}
    }
}
