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
    let dom = "https://freemusicarchive.org"
    let managedObjectContext =
        (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    
    static let sharedmanager = JsonDCoreManager()
    
    func getData (limit: Int, callback: (([DataMusic])->())?)   {
        
        let entityDescription =
            NSEntityDescription.entityForName("MusicData",
                                              inManagedObjectContext: managedObjectContext)
        
           let url = "https://freemusicarchive.org/recent.json"
           
           Alamofire.request(.GET, url).responseArray(keyPath: "aTracks")  {[unowned self] (response: Response< [DataMusic], NSError>) in
                switch response.result {
                    
                case .Success(let music):
                    
                    for (ind, elm) in music.enumerate() {
                       let MData = MusicData(entity: entityDescription!,
                                              insertIntoManagedObjectContext: self.managedObjectContext)
                        MData.id = elm.id
                        MData.title = elm.title
                        MData.image_file = elm.imageFile
                        MData.duration = elm.duration
                       // MData.file = elm.urlFile
                        MData.file = HttpDownloader.loadFileSync(elm.urlFile)
                        
                       if !self.filtred(elm.id) {
                            do {
                                try  self.managedObjectContext.save()
                            }
                            catch{
                                let err = error as  NSError
                                print(err)
                            }
                        }
                        
                        if ind > limit { break }
                    }
                    
                case .Failure(let error):
                    callback?([DataMusic]())
                    print(error)
                   
                }
                dispatch_async(dispatch_get_main_queue(), {
                    callback?(self.getCoreData())
                })
                
            }      
    }
    
    func getCoreData() -> [DataMusic] {
        
        let arrDataM: [DataMusic]!
       
        let result = try! self.managedObjectContext.executeFetchRequest(request)
        
        arrDataM = result.map({ (element: AnyObject) -> DataMusic in
            
            let elData = DataMusic()
            elData.id =  element.valueForKey("id") as! String
            elData.title = element.valueForKey("title") as! String
            elData.duration = element.valueForKey("duration") as! String
            elData.urlFile = element.valueForKey("file") as! String
            elData.imageFile = element.valueForKey("image_file") as! String
            
            return elData
        })
        
     return arrDataM
        
    }    
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest(entityName: "MusicData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let myManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let myPersistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
     
        do {
            try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: myManagedObjectContext)
        } catch let error as NSError {
            print(error)
        }
      
    }
    
    func filtred(fData: String) -> Bool  {
        let fetchRequest = NSFetchRequest(entityName:"MusicData")
        let predicate = NSPredicate(format: "id = %@", fData)
        fetchRequest.predicate = predicate
        
        let myManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var result: AnyObject!
        do {
           result = try  myManagedObjectContext.executeFetchRequest(fetchRequest)
        } catch  let error as NSError {
            print(error) }
       
        if result.count != 0 {
            return true }
        return false
    }
    

    
}
