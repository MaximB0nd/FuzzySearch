//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

public protocol FuzzySearchable: StringProtocol {
    var searchableName: String { get }
}
