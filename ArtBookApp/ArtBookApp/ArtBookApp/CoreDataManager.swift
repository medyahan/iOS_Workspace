//
//  CoreDataManager.swift
//  ArtBookApp
//
//  Created by Medya Han on 2.12.2024.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    func fetchArts() throws -> [Art] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Art> = Art.fetchRequest()
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    func deleteArt(_ art: Art) throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(art)
        try context.save()
    }
}
