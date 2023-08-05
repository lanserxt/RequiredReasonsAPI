//
//  Reason.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import Foundation

struct Reason: Decodable, Identifiable {
    let id: String
    let info: String
}

extension Reason: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(info)
    }
}
