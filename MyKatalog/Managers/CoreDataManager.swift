//
//  CoreDataManager.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 06/11/21.
//
import Foundation
import CoreData

class CoreDataManager {
    private static var persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "KatalogModel")
                container.loadPersistentStores { description, error in
                    if let error = error {
                         fatalError("Unable to load persistent stores: \(error)")
                    }
                }
                return container
            }()
        
        var context: NSManagedObjectContext {
            return Self.persistentContainer.viewContext
        }

    func saveFavorite(id: Int64, name: String, backgroundImage: String, releasedDate: String, rating: Float){
        var isAlready = false
        let games = getAllFavorites()
        
        for game in games {
            if(game.id == id){
                isAlready = true
            }
        }
        if(!isAlready){
            let favoriteGame = FavoriteGames(context: CoreDataManager.persistentContainer.viewContext)
            favoriteGame.name = name
            favoriteGame.id = id
            favoriteGame.rating = rating
            favoriteGame.background_image = backgroundImage
            favoriteGame.released_date = releasedDate
            
            do {
                try CoreDataManager.persistentContainer.viewContext.save()
            } catch {
                print("Failed to save games \(error)")
            }
        }else{
            print("Is already favorite!")
        }
    }
    
    func deleteFavorite(favoriteGames: FavoriteGames){
        CoreDataManager.persistentContainer.viewContext.delete(favoriteGames)
        
        do {
            try CoreDataManager.persistentContainer.viewContext.save()
        } catch {
            CoreDataManager.persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func getAllFavorites() -> [FavoriteGames] {
        let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
        
        do {
            return try CoreDataManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
}

public extension NSManagedObject {
    convenience init(usedContext: NSManagedObjectContext) {
            let name = String(describing: type(of: self))
            let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
            self.init(entity: entity, insertInto: usedContext)
        }
}
