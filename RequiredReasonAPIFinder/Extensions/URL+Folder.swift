//
//  URL+Folder.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import Foundation

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
