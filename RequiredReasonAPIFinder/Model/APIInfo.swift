//
//  APIInfo.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import Foundation

struct APIInfo: Decodable {
    let type: Int
    let name: String
    let apiType: String
    let funcs: [String]
    let reasons: [Reason]
}

extension APIInfo: Identifiable {
    var id: Int {
        type
    }
}

extension APIInfo: Equatable {
    static func == (lhs: APIInfo, rhs: APIInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension APIInfo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
    }
}


