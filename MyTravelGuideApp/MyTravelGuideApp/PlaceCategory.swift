//
//  PlaceCategory.swift
//  MyTravelGuideApp
//
//  Created by Medya Han on 3.12.2024.
//

import Foundation

enum PlaceCategory: String, Codable, CaseIterable {
    case none
    case food
    case coffee
    case museum
    case park
    case shopping
    
    var description: String {
        switch self {
        case .none: return "Select a category"
        case .food: return "Food"
        case .coffee: return "Coffee"
        case .museum: return "Museum"
        case .park: return "Park"
        case .shopping: return "Shopping"
        }
    }
}
