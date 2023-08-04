//
//  SearchInfo.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import Foundation


struct APIInfo: Decodable, Identifiable, Equatable, Hashable {
       
    let type: Int
    let name: String
    let funcs: [String]
    let reasons: [Reason]
    
    var id: Int {
        type
    }
    
    static func == (lhs: APIInfo, rhs: APIInfo) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
    }
}

struct Reason: Decodable, Identifiable, Hashable {
    let id: String
    let info: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(info)
    }
}
