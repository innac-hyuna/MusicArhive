//
//  Extention.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/22/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation
import UIKit

extension NSTimeInterval {
    var strigTime: String { return String(format: "%02d:%02d", (Int(self/60)),(Int(self%60)))}
    
}

extension Int {
    func randomNumber() -> Int {
        let range = 0...self
        let min = range.startIndex
        let max = range.endIndex
        return Int(arc4random_uniform(UInt32(max - min))) }
}

extension UIColor {
    
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
    
    static func bgColor() -> UIColor {
        return UIColor(hexString: "#8f8f8d")
    }
    
    static func bgGridColor() -> UIColor {
        return UIColor(hexString: "#8a6642")
    }
    
    static func bgFildColor() -> UIColor {
        return UIColor(hexString: "#b8997a")
    }
    
    static func bgSelectedFildColor() -> UIColor {
        return UIColor(hexString: "#b86614")
    }
    
    static func textColor() -> UIColor {
        return UIColor(hexString: "#ffffe6")
    }
    
   

}

extension UIFont {
    static func MyTextFont(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Futura", size: size)!
    }
}