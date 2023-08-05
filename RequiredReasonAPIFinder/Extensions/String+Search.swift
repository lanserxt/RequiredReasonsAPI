//
//  String+Search.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import Foundation

extension String {
    func containsAny(_ list: [String]) -> Bool {
        for item in list {
            if contains(item) {
                return true
            }
        }
        return false
    }
}
