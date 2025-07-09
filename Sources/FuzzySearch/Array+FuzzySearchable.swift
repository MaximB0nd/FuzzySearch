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
            if distance <= maxWeightDistance && element.searchableName.contains(input){
                results.append((element, distance))
            }
        }
        
        guard !results.isEmpty else {
            for element in self {
                if element.searchableName.contains(input){
                    results.append((element, 0))
                }
            }
            
            print("No res in fuzzySearch")
            return results.sorted { $0.0.searchableName.range(of: input)!.lowerBound < $1.0.searchableName.range(of: input)!.lowerBound }.map(\.0)
        }
        
        print("Exist res in fuzzySearch")
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}
