//
//  DJsonManager.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import CoreData

@objc( MusicData )
class MusicData: NSManagedObject {
    @NSManaged  var id : String?
    @NSManaged  var title : String?
    @NSManaged  var file : String?
    @NSManaged  var image_file : String?
    @NSManaged  var duration: String?
    
}

class JsonDCoreManager {
    var request = NSFetchRequest(entityName: "MusicData")
    let managedObjectContext =
        (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    
    static let sharedmanager = JsonDCoreManager()
    
    func getData (callback: (([DataMusic])->())?)   {
        
        let entityDescription =
            NSEntityDescription.entityForName("MusicData",
                                              inManagedObjectContext: managedObjectContext)
       
        
        // Delete all coreData row
        deleteAll()
        
            let url = "https://freemusicarchive.org/recent.json"
            
            Alamofire.request(.GET, url).responseArray(keyPath: "aTracks")  {[unowned self] (response: Response< [DataMusic], NSError>) in
                switch response.result {
                    
                case .Success(let music):
                    
                    for elm in music {
                        let MData = MusicData(entity: entityDescription!,
                                              insertIntoManagedObjectContext: self.managedObjectContext)
                        MData.id = elm.id
                        MData.title = elm.title
                        MData.image_file = elm.image_file
                        MData.duration = elm.duration
                        MData.file = elm.duration
                        
                        do {
                            try  self.managedObjectContext.save()
                        }
                        catch{
                            let err = error as  NSError
                            print(err)
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    callback?(self.getCData())
                })
                
            }
      
    }
    
    func getCData() -> [DataMusic] {
        
        let arrDataM: [DataMusic]!
       
        let result = try! self.managedObjectContext.executeFetchRequest(request)
        
        arrDataM = result.map({ (element: AnyObject) -> DataMusic in
            
            let elData = DataMusic()
            elData.id =  element.valueForKey("id") as! String
            elData.title = element.valueForKey("title") as! String
            elData.duration = element.valueForKey("duration") as! String
            elData.image_file = element.valueForKey("image_file") as! String
            
            return elData
        })
        
     return arrDataM
        
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest(entityName: "MusicData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // delegate objects
        let myManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let myPersistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator

        do {
            try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: myManagedObjectContext)
        } catch let error as NSError {
            print(error)
        }
    }
        
    
}
