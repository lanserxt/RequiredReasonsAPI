//
//  DetectedUsage.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import Foundation


struct DetectedUsage {
    let fileURL: URL
    let api: APIInfo
}

extension DetectedUsage: Identifiable {
    var id: String {
        fileURL.absoluteString
    }
}

extension DetectedUsage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fileURL.absoluteString)
    }
}
