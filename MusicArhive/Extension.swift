//
//  Extention.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/22/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    var strigTime: String { return String(format: "%02d:%02d", (Int(self/60)),(Int(self%60)))}
    
}