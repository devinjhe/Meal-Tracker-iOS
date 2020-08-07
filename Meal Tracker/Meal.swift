//
//  Meal.swift
//  Meal Tracker
//
//  Created by Devin He on 11/04/2020.
//  Copyright © 2020 Devin He. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    //MARK: Properties
    var name: String
    var image: UIImage?
    var rating: Int
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
    }
    
    //MARK: Initialisation
    init?(name: String, image: UIImage?, rating: Int) {
        //super.init() gets called automatically
        
        // Name should not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Rating should be between 0-5 inclusive
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        // Initialise properties
        self.name = name
        self.image = image
        self.rating = rating
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(image, forKey: PropertyKey.image)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        // The name is required so if we cannot deocde a name string, the initialiser should fail
        guard let name = decoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Since image is an optional property of Meal, just use conditional cast
        let image = decoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let rating = decoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call the designated initialiser
        self.init(name: name, image: image, rating: rating)
    }
}
