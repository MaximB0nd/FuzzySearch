//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension Array where Element: FuzzySearchable {
    func fuzzySearch(input: String, maxWeightDistance: Int = 5, minContains: Int = 2) -> [Element] {
        guard !input.isEmpty else { return [] }
        
        var results: [(Element, Int)] = []
        
        for element in self {
            let target = element.searchableName
            if abs(input.count - target.count) > maxWeightDistance {
                continue
            }
            
            let distance = input.levenshteinDistance(to: target)
            if distance <= maxWeightDistance && element.searchableName.containsCount(of: input) > minContains {
                print(element.searchableName, distance)
                if element.searchableName.contains(input) {
                    results.append((element, distance/2))
                } else {
                    results.append((element, distance))
                }
            }
        }
        
        if results.contains(where: {$0.0.searchableName == input}) { return results.filter { $0.0.searchableName == input }.map { $0.0 }}
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}

fileprivate extension String {
    func containsCount(of other: String, caseSensitive: Bool = true) -> Int {
        guard !other.isEmpty else { return 0 }
    
        var charCounts: [Character: Int] = [:]
        for char in other {
            let key = caseSensitive ? char : Character(char.lowercased())
            charCounts[key, default: 0] += 1
        }
        
        var matchCount = 0

        for char in self {
            let key = caseSensitive ? char : Character(char.lowercased())

            if let count = charCounts[key], count > 0 {
                matchCount += 1
                charCounts[key] = count - 1
            }
        }
        
        return matchCount
    }
}
