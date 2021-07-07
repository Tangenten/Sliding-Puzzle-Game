//
//  database.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-11-09.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Database {
    
    static func createFromDict(entity: String, dict: Dictionary<String, Any>){
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dbEntity = NSEntityDescription.entity(forEntityName: entity, in: coreDataContext)!
        
        let dbCreate = NSManagedObject(entity: dbEntity, insertInto: coreDataContext)
        
        for (key, value) in dict {
            dbCreate.setValue(value, forKey: key)
        }
        
        
        do {
            try coreDataContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func retrieveLevels(entity: String, key: String, value: String) -> [Level]? {
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dbRetrieve = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        dbRetrieve.predicate = NSPredicate(format: "\(key) = %@", value)
        
        do {
            let dbFetched = try coreDataContext.fetch(dbRetrieve) as! [Level]
            
            return dbFetched
        }
        catch {
            print("Failed fetch request")
        }
        return nil
    }
    
    static func retrieveLevelsFromDict(entity: String, dict: Dictionary<String, String>) -> [Level]? {
        var tupleList = Array<(String, String)>()
        for (key, value) in dict {
            tupleList.append((key, value))
        }
        
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dbRetrieve = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        dbRetrieve.predicate = NSPredicate(format: "\(tupleList[0].0) = %@ && \(tupleList[1].0) = %@ && \(tupleList[2].0) = %@", tupleList[0].1, tupleList[1].1,tupleList[2].1)
        
        do {
            let dbFetched = try coreDataContext.fetch(dbRetrieve) as! [Level]
            
            return dbFetched
        }
        catch {
            print("Failed fetch request")
        }
        return nil
    }
    
    static func retrieveCount(entity: String, key: String, value: String) -> Int? {
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dbRetrieve = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        dbRetrieve.predicate = NSPredicate(format: "\(key) = %@", value)
        
        do {
            let dbFetchedCount = try coreDataContext.count(for: dbRetrieve)
            
            return dbFetchedCount
        }
        catch {
            print("Failed fetch request")
        }
        return nil
    }
    
    static func retrieveAllLevels(entity: String) -> [Level]? {
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dbRetrieve = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let dbFetched = try coreDataContext.fetch(dbRetrieve) as! [Level]
            
            return dbFetched
        }
        catch {
            print("Failed fetch request")
        }
        return nil
    }
    
    static func updateFromDict(entity: String, key: String, value: String, dict: Dictionary<String, Any>){
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "\(key) = %@", value)
        
        do {
            let objectsUpdate = try coreDataContext.fetch(fetchRequest)
            
            let objectUpdate = objectsUpdate[0] as! NSManagedObject
            
            for (key, value) in dict {
                objectUpdate.setValue(value, forKey: key)
            }
            
            do {
                try coreDataContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    static func deleteRow(entity: String, key: String, value: String){
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let deleteFetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        deleteFetch.predicate = NSPredicate(format: "\(key) = %@", value)
        do {
            let objectsToDelete = try coreDataContext.fetch(deleteFetch)
            
            let objectToDelete = objectsToDelete[0] as! NSManagedObject
            coreDataContext.delete(objectToDelete)
            
            do {
                try coreDataContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    static func deleteAllRows(entity : String) {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        deleteFetch.predicate = NSPredicate(value:true)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print ("There was an error")
        }
    }
    
}
