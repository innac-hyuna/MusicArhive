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
    @NSManaged  var id : NSNumber?
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
    
    func getData (callback: ((Bool)->())?) {
        
        let entityDescription =
            NSEntityDescription.entityForName("MusicData",
                                              inManagedObjectContext: managedObjectContext)
        let MData = MusicData(entity: entityDescription!,
                                  insertIntoManagedObjectContext: managedObjectContext)
        
        let url = "https://freemusicarchive.org/recent.json"
        
        Alamofire.request(.GET, url).responseArray(keyPath: "aTracks")  {[unowned self] (response: Response< [DataMusic], NSError>) in
            switch response.result {
                
            case .Success(let music):
                
                for elm in music {
                    
                   MData.id = Int(elm.id)
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
             callback?(true)
           })
            
         }
    }
}