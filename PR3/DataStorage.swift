//
//  DataStorage.swift
//  PR3
//
//  Created by Alberto Revel on 12/6/18.
//  Copyright © 2018 uoc. All rights reserved.
//

import Foundation

class DataStorage {
    let userDefaults = UserDefaults.standard
    
    // Stores a given Profile object with a key
    func saveProfile(profile: Profile, key: String) {
        
        if let encoded = try? JSONEncoder().encode(profile) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    // Returns a Profile object stored in device for a key, if exists.
    func getProfile(key: String) -> Profile? {
        
        if let retrievedObject = UserDefaults.standard.data(forKey: key),
            let profile = try? JSONDecoder().decode(Profile.self, from: retrievedObject) {
            return profile
        }
        
        return nil
    }
}
