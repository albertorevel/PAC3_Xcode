//
//  Storage.swift
//  PR3
//
//  Created by Alberto Revel on 22/5/18.
//  Copyright © 2018 uoc. All rights reserved.
//

import Foundation
import UIKit

class Storage {
    
    let cache = NSCache<NSString,UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    //        let documentsDirectories =
    //            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        let documentDirectory = documentsDirectories.first!
    //
    //        let imageUrl = documentDirectory.appendingPathComponent("profile_image")
    //
    
    
    //        cache.setObject(image, forKey: "profile_image")
    
}
