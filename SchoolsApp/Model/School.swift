//
//  School.swift
//  SchoolsApp


import Foundation
import CSV

class School: Decodable {
    var dbn:String
    var school_name:String
    var overview_paragraph:String
    var phone_number:String
    var location:String
    var schoolsScores: SchoolScores?
    var address:String {
        get {
            let toArray = location.components(separatedBy: "(")
            return toArray.first!
        }
    }
    
    init(dictionary:[String:Any]) {
        self.dbn = dictionary["dbn"] as! String
        self.school_name = dictionary["school_name"] as! String
//        if let aString = dictionary["location"] as? String {
//            print(aString)
//            let toArray = aString.components(separatedBy: "(")
//            self.address = toArray.first
//            print(self.address)
//        }
        self.location = dictionary["location"] as! String
        self.overview_paragraph = dictionary["overview_paragraph"] as! String
        self.phone_number = dictionary["phone_number"] as! String
    }
//    init(dictionary:CSVReader) {
//        self.dbn = dictionary["dbn"]!
//        self.name = dictionary["school_name"]!
//        self.location = dictionary["location"]!
//        self.overviewParagraph = dictionary["overview_paragraph"]!
//        self.phoneNumber = dictionary["phone_number"]!
//    }
}

class Location:Decodable {
    var results: [Result]?
    var status: String?
}

class Result: Decodable {
    var place_id:String?
    var formatted_address: String?
}
