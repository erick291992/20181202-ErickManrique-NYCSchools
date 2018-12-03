//
//  School.swift
//  SchoolsApp
//
//  Created by Erick Manrique on 3/15/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation
import CSV

class School {
    var dbn:String
    var name:String
    var address:String?
    var overviewParagraph:String
    var phoneNumber:String
    
    init(dictionary:CSVReader) {
        self.dbn = dictionary["dbn"] as! String
        self.name = dictionary["school_name"] as! String
        if let aString = dictionary["location"] as? String {
            print(aString)
            let toArray = aString.components(separatedBy: "(")
            self.address = toArray.first
//            print(self.address)
        }
        self.overviewParagraph = dictionary["overview_paragraph"] as! String
        self.phoneNumber = dictionary["phone_number"] as! String
    }
}

class Location:Decodable {
    var results: [Result]?
    var status: String?
}

class Result: Decodable {
    var place_id:String?
    var formatted_address: String?
}
