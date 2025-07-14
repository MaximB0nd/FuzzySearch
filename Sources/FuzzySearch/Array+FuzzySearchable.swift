//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public extension Array where Element: FuzzySearchable {
    func fuzzySearch(input: String) -> [Element] {
        
        let top = 1
        
        var input = input.lowercased()
        input.removeAll { $0 == " " }
        
        guard !input.isEmpty else { return [] }
        
        var results: [(Element, Int)] = []
        
        for element in self {
                
            let distance = element.levenshteinDistance(to: input)
            
            if element.searchableName.count > 1 &&
                element.searchableName.contains(input) {
                results.append( (element, 0) )
            } else {
                if distance < element.searchableName.count - 2 {
                    results.append( (element, distance) )
                }
            }
            
            print(element.searchableName, distance)
        }
        
        if results.contains(where: { $0.0.searchableName == input} ) {
            return results.filter { $0.0.searchableName == input }.map { $0.0 }
        }
        
        let distances = results.map(\.1)
        
        let maxes = getMin(array: distances, k: top)
        
        results = results.filter({maxes.contains($0.1)})
        results.sort { $0.1 < $1.1 }
        return results.map { $0.0 }
    }
}

func getMin(array: [Int], k: Int) -> [Int] {
    
    guard k > 0 else {
        return []
    }
    
    var array = array
    var result = [Int]()
    
    for _ in 0..<k{
        let max = array.min() ?? 0
        array.removeAll(where: {$0 == max})
        result.append(max)
    }
    
    return result
}
