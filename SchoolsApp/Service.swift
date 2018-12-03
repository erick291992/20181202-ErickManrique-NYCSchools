//
//  School.swift
//  SchoolsApp

import Foundation
import Alamofire
import GooglePlaces

class Service {
    
    static let shared = Service()
    
    func getLocationInfo(address:String, completion:@escaping (_ result: Location?, _ error: Error?) -> Void){
        
        var parameters = [String:Any]()
        parameters["address"] = address
        parameters["key"] = Key.googleGeo
        
        Alamofire.request(Api.googleGeo, parameters: parameters).responseJSON { (response) in
            
            if let error = response.error {
                completion(nil, error)
            } else {
                print("Request: \(String(describing: response.request))")
                if let data = response.data {
                    do {
                        let location = try JSONDecoder().decode(Location.self, from: data)
                        completion(location, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func getFirstPhotoForPlace(address:String, completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        getLocationInfo(address: address) { (location, error) in
            if let error = error {
                completion(nil,error)
            } else {
                if let count = location?.results?.count, count > 0 {
                    if let placeId = location?.results?[0].place_id {
                        self.getFirstPhotoForPlace(placeID: placeId, completion: completion)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func getFirstPhotoForPlace(placeID: String, completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        print("placeIDE:", placeID)
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            print("waiting here")
            if let error = error {
                print("error getFirstPhotoForPlace")
                completion(nil, error)
            } else {
                print("no error getFirstPhotoForPlace")
                print(photos?.results,"aaaaaaaa")
                if let firstPhoto = photos?.results.first {
                    self.getImageFromMetadata(photoMetadata: firstPhoto, completion: completion)
                } else {
                    print("no photo available")
                    completion(nil, nil)
                }
            }
        }
    }
    
    private func getImageFromMetadata(photoMetadata: GMSPlacePhotoMetadata, completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                completion(nil,error)
            } else {
                completion(photo,nil)
            }
        })
    }
    
    func getSchools(completion:@escaping (_ schools: [School]?, _ error: Error?) -> Void) {
        
        Alamofire.request(Api.highSchools, parameters: nil).responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                print("Request: \(String(describing: response.request))")
                if let data = response.data {
                    do {
                        let schools = try JSONDecoder().decode([School].self, from: data)
                        completion(schools, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func getSchoolScores(dbn:String, completion:@escaping (_ scores: SchoolScores?, _ error: Error?) -> Void) {
        var parameters = [String:Any]()
        parameters["dbn"] = dbn
        
        Alamofire.request(Api.highSchoolScore, parameters: parameters).responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                print("Request: \(String(describing: response.request))")
//                print("Response: \(String(describing: response.response))")
//                print("Result: \(response.result)")
                if let json = response.result.value {
//                    print("JSON: \(json)") // serialized json response
                }
                if let data = response.data {
                    do {
                        let scores = try JSONDecoder().decode([SchoolScores].self, from: data).first
                        completion(scores, nil)
                    } catch {
                        print("error in req:",error)
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
}
