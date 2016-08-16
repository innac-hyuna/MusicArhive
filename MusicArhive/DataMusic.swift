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
    var id: String!
    var title: String!
    var file: String!
    var duration: String!
    var image_file: String!
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map["track_id"]
        title <- map["track_title"]
        file <- map["track_file"]
        duration <- map["track_duration"]
        image_file <- map["track_image_file"]
    }
   
}