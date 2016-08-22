//
//  DataMusic.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation
import ObjectMapper

class DataMusic: Mappable {
    
    var id = ""
    var title = ""
    var urlFile = ""
    var duration = ""
    var imageFile = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map["track_id"]
        title <- map["track_title"]
        urlFile <- map["track_file_url"]
        duration <- map["track_duration"]
        imageFile <- map["track_image_file"]
    }
   
}