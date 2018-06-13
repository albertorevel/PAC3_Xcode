//
//  Storage.swift
//  PR3
//
//  Created by Alberto Revel on 22/5/18.
//  Copyright © 2018 uoc. All rights reserved.
//

import Foundation
import UIKit

class ImageStorage {
    
    let dataPath:String
    
    init() {
        
        dataPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/"
    }
    
    // Stores an image with a given key in device's filsystem
    func saveImage(_ image: UIImage, forKey key: String) {
        let path = dataPath + "\(key).png"
        let url: URL = URL(fileURLWithPath: path)
        
        try? UIImagePNGRepresentation(image)?.write(to: url)
    }
    
    // Returns an image with a given key, stored in device's filsystem, if exists
    func image(forKey key: String) -> UIImage? {
        
        let path = dataPath + "\(key).png"
        let url: URL = URL(fileURLWithPath: path)
        
        guard FileManager.default.fileExists(atPath: path),
            let imageData: Data = try? Data(contentsOf: url) ,
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                return nil
        }
        
        return image
    }
}
