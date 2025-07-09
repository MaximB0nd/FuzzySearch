//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension Array where Element: FuzzySearchable {
    func fuzzySearch(input: String, maxWeightDistance: Int = 5, minLength: Int = 3) -> [Element] {
        guard !input.isEmpty else { return [] }
        
        var results: [(Element, Int)] = []
        
        if input.count > minLength {
            for element in self {
                let target = element.searchableName
                if abs(input.count - target.count) > maxWeightDistance {
                    continue
                }
                
                let distance = input.levenshteinDistance(to: target)
                if distance <= maxWeightDistance && distance != element.searchableName.count {
                    results.append((element, distance))
                }
            }
        }
        
        print("Exist res in fuzzySearch")
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}
