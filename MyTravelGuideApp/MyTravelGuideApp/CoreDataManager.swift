//
//  CoreDataManager.swift
//  MyTravelGuideApp
//
//  Created by Medya Han on 3.12.2024.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    func fetchPlaces() throws -> [Place] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    func deletePlace(_ place: Place) throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(place)
        try context.save()
    }
}


