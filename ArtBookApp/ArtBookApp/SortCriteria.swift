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
            return (art1.name ?? "") > (art2.name ?? "")
        case .creationDate:
            // Varsayılan sıralama zaten eklenme sırasıdır
            return true
        case .year:
            return art1.year < art2.year
        }
    }
}
