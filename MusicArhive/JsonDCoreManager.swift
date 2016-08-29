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
import MagicalRecord

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
    let managedObjectRootContext =
        (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectRootContext
    
    static let sharedmanager = JsonDCoreManager()
    
    func getData (limit: Int, callback: (([DataMusic])->())?)   {
 
           let url = "https://freemusicarchive.org/recent.json"
        
           Alamofire.request(.GET, url).responseArray(keyPath: "aTracks")  {[unowned self] (response: Response< [DataMusic], NSError>) in
                switch response.result {
                    
                case .Success(let music):
                    
                    for (ind, elm) in music.enumerate() {
                        let MData = MusicData.MR_createEntityInContext(self.managedObjectContext)
                     
                        if !self.filtred(elm.id) {
                            MData?.id = elm.id
                            MData?.title = elm.title
                            MData?.image_file = elm.imageFile
                            MData?.duration = elm.duration
                            MData?.file = HttpDownloader.loadFileSync(elm.urlFile)
                     
                    } //MR_save()
                        if ind > limit { break }
                    }
                    
                case .Failure(let error):
                    callback?([DataMusic]())
                    print(error)
                   
                }
                dispatch_async(dispatch_get_main_queue(), {
                   /* self.managedObjectContext.MR_saveToPersistentStoreWithCompletion({ (resBool, err) in
                        print(resBool)
                        print(err)
                    })*/
                 
                   try!  self.managedObjectContext.save()
                         
                    
                    callback?(self.getCoreData())
               })
                
            }
       
    }
    
    func getCoreData() -> [DataMusic] {
        
        let arrDataM: [DataMusic]!
       
       //let result = try! managedObjectContext.executeFetchRequest(request)
        
       let result: NSArray = MusicData.MR_findAll()!
        
        arrDataM = result.map { (element: AnyObject) -> DataMusic in
            
          let elData = DataMusic()
          elData.id =  element.valueForKey("id") as! String
          elData.title = element.valueForKey("title") as! String
          elData.duration = element.valueForKey("duration") as! String
          elData.urlFile = element.valueForKey("file") as! String
          elData.imageFile = element.valueForKey("image_file") as! String
            
          return elData
        }
        
     return arrDataM
        
    }    
    
    func deleteAll() {
       /* let fetchRequest = NSFetchRequest(entityName: "MusicData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let myManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let myPersistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
     
        do {
            try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: myManagedObjectContext)
        } catch let error as NSError {
            print(error)
        }*/
    }
    
    func filtred(fData: String) -> Bool  {
        let fetchRequest = NSFetchRequest(entityName:"MusicData")
        let predicate = NSPredicate(format: "id = %@", fData)
        fetchRequest.predicate = predicate
       
        var result: AnyObject!
        do {
           result = try  managedObjectContext.executeFetchRequest(fetchRequest)
        } catch  let error as NSError {
            print(error) }
       
        if result.count == 0 {
            return false
        }
        return true
    }
    
   
    
}
