//
//  File.swift
//  FuzzySearch
//
//  Created by Максим Бондарев on 09.07.2025.
//

import Foundation

extension String: FuzzySearchable {
    public var searchableName: String {
        self
    }
}
