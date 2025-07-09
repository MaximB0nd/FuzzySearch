//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension Array where Element: FuzzySearchable {
    func fuzzySearch(input: String, maxWeightDistance: Int = 5) -> [Element] {
        guard !input.isEmpty else { return [] }
        
        var results: [(Element, Int)] = []
        
        for element in self {
            let target = element.searchableName
            if abs(input.count - target.count) > maxWeightDistance {
                continue
            }
            
            let distance = input.levenshteinDistance(to: target)
            if distance <= maxWeightDistance {
                print(element.searchableName, distance)
                if element.searchableName.contains(input) {
                    results.append((element, distance/2))
                } else {
                    results.append((element, distance))
                }
            }
        }
        
        
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}

fileprivate extension String {
    func contains(_ string: String) -> Int {
        var count = 0
        
        for i in stride(from: 0, to: count - string.count + 1, by: 1) {
            let substring = String(self[index(startIndex, offsetBy: i)..<index(startIndex, offsetBy: i + string.count)])
            if substring == string {
                count += 1
            }
        }
        
        return count
    }
}
