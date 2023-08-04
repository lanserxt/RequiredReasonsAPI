//
//  SearchInfo.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import Foundation


struct APIInfo: Decodable, Identifiable, Equatable {
       
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
}

struct Reason: Decodable, Identifiable {
    let id: String
    let info: String
}
