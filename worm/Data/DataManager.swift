//
//  DataManager.swift
//  
//
//  Created by Administrator on 05/05/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class DataManager {

    public   static let sharedInstance = DataManager()

    private init() {} //This prevents others from using the default '()' initializer for this class.


    func saveCard( id : String, name: String, caption: String, photoUrl: String, VideoUrl: String, liked: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
        let newCard = NSManagedObject(entity: entity!, insertInto: context)
        newCard.setValue(id, forKey: "id")
        newCard.setValue(false, forKey: "liked")
        newCard.setValue(name, forKey: "name")
        newCard.setValue(photoUrl, forKey: "photoUrl")
        newCard.setValue(VideoUrl, forKey: "videoUrl")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }




    }
        func CardsSaved() -> Bool{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            //   request.returnsObjectsAsFaults = false
            //  let predicate = NSPredicate(format: "id == %i", id)
            // Assigns the predicate to the request
            // request.predicate = predicate
            do {
                let result = try context.fetch(request)
                if result.count > 0 {
                    return true
                } else {
                    return false
                }
            } catch {
    
                print("Failed")
            }
            return false
        }
    
    func updateLiked(id: String, liked: Bool){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            //   request.returnsObjectsAsFaults = false
            let predicate = NSPredicate(format: "id == %@", id)
    
            // Assigns the predicate to the request
            request.predicate = predicate
            do {
                let result = try context.fetch(request)
                if result.count > 0 {
                   
                    do {
                         for data in result as! [NSManagedObject] {
                         data.setValue(liked, forKey: "liked")
                        }
                        try context.save()
                    } catch {
                    print("Failed saving")
                    }
                } else {
                    //return false
                }
            } catch {
    
                print("Failed")
            }
           // return false
        }
    
    
//    func getLikes() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "title") as! String)
//
//            }
//
//        } catch {
//
//            print("Failed")
//        }
//    }

//    func deleteLike(id: Int) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//        let predicate = NSPredicate(format: "id == %i", id)
//
//        // Assigns the predicate to the request
//        request.predicate = predicate
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//
//                context.delete(data) //for delete
//            }
//            do {
//                try context.save()
//            } catch {
//                print("Failed saving")
//            }
//        } catch {
//
//            print("Failed")
//        }
//    }

//    func isLiked(id: Int) -> Bool{
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//        //   request.returnsObjectsAsFaults = false
//        let predicate = NSPredicate(format: "id == %i", id)
//
//        // Assigns the predicate to the request
//        request.predicate = predicate
//        do {
//            let result = try context.fetch(request)
//            if result.count > 0 {
//                return true
//            } else {
//                return false
//            }
//        } catch {
//
//            print("Failed")
//        }
//        return false
//    }

}
