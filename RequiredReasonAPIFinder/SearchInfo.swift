//
//  SearchInfo.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import Foundation


struct APIInfo: Decodable {
    let type: Int
    let name: String
    let funcs: [String]
    let reasons: [Reason]
}

struct Reason: Decodable {
    let id: String
    let info: String
}
