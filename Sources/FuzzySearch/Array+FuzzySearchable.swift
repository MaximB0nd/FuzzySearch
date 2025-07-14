//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension Array where Element: FuzzySearchable {
    func fuzzySearch(input: String) -> [Element] {
        
        let top = 3
        
        let maxWeightDistance: Int = 6, minContains: Int = 1
        
        guard !input.isEmpty else { return [] }
        
        var results: [(Element, Int)] = []
        
        for element in self {
            let target = element.searchableName
            
            let distance = element.levenshteinDistance(to: target)
            
            if element.searchableName.count > 1 &&
                element.searchableName.contains(target) {
                results.append( (element, 1) )
            } else {
                results.append( (element, distance) )
            }
            
        }
        
        if results.contains(where: {$0.0.searchableName == input}) {
            return results.filter { $0.0.searchableName == input }.map { $0.0 }
        }
        
        let distances = results.map(\.1)
        
        let maxes = getMax(array: distances, k: top)
        
        results = results.filter({maxes.contains($0.1)})
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}

func getMax(array: [Int], k: Int) -> [Int] {
    
    guard k > 0 else {
        return []
    }
    
    var array = array
    var result = [Int]()
    
    for _ in 0..<k{
        let max = array.max() ?? 0
        array.removeAll(where: {$0 == max})
        result.append(max)
    }
    
    return result
}
