//
//  SortCriteria.swift
//  ArtBookApp
//
//  Created by Medya Han on 2.12.2024.
//

import Foundation

enum SortCriteria {
    case name
    case creationDate
    case year
    
    func compare(_ art1: Art, _ art2: Art) -> Bool {
        switch self {
        case .name:
            return (art1.name ?? "").localizedCompare(art2.name ?? "") == .orderedAscending // Türkçe sıralama
        case .creationDate:
            return (art1.creationDate ?? Date.distantPast) > (art2.creationDate ?? Date.distantPast) // En yeni önce
        case .year:
            return art1.year < art2.year
        }
    }
}
