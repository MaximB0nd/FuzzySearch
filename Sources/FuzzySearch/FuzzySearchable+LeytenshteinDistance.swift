//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension FuzzySearchable {
    func levenshteinDistance(to other: String) -> Int {
        let s = self.searchableName.lowercased()
        let t = other.lowercased()
        
        if s.isEmpty { return t.count }
        if t.isEmpty { return s.count }
        
        var prev = Array(0...t.count)
        var curr = Array(repeating: 0, count: t.count + 1)
        
        let sChars = Array(s)
        let tChars = Array(t)
        
        for i in 1...sChars.count {
            curr[0] = i
            
            for j in 1...tChars.count {
                let cost = sChars[i-1] == tChars[j-1] ? 0 : 1
                curr[j] = Swift.min(
                    Int(prev[j] + 1),
                    Int(curr[j-1] + 1),
                    Int(prev[j-1] + cost)
                )
            }
            
            prev = curr
            curr = Array(repeating: 0, count: t.count + 1)
        }
        
        return prev[t.count]
    }
}
