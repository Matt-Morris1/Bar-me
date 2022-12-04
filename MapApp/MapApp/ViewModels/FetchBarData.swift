//
//  FetchBarData.swift
//  MyAppUIKit
//
//  Created by Matthew Morris on 6/4/22.
//

import Foundation
import CoreLocation

extension MapViewController {
    
    func retrieveBars(latitude: Double,
                      longitude: Double,
                      category: String,
                      limit: Int,
                      sortBy: String,
                      locale: String,
                      completionHandler: @escaping ([Bars]?, Error?) -> Void) {
        
        let apikey = "0g0Mg9tmiapxosl3_LQ-mMgVi4l2pSd1fv6D9DHprV7gIGFNLYyvx_95EzIC6NATubQXGMLmLIfXUhtU_6kjpyVNFiYS7LLOCQ4TO30Ke4qz_a2hudBkJMSCbiWcYnYx"
        
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
        
        
        let url = URL(string: baseURL)
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                
                var barsList: [Bars] = []
                
                for business in businesses {
                    var bar = Bars()
                    bar.name = business.value(forKey: "name") as? String
                    bar.id = business.value(forKey: "id") as? String
                    bar.rating = business.value(forKey: "rating") as? Float
                    bar.price = business.value(forKey: "price") as? String
                    bar.is_closed = business.value(forKey: "is_closed") as? Bool
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    bar.address = address?.joined(separator: "\n")
                    bar.latitude = business.value(forKeyPath: "coordinates.latitude") as? Double
                    bar.longitude = business.value(forKeyPath: "coordinates.longitude") as? Double
                    bar.image_url = business.value(forKey: "image_url") as? String
                    
                    barsList.append(bar)
                }
                
                completionHandler(barsList, nil)
            } catch {
                print("Caught error")
            }
        }.resume()
    }
}

extension BarListTableViewController {
    
    func retrieveBars(latitude: Double,
                      longitude: Double,
                      category: String,
                      limit: Int,
                      sortBy: String,
                      locale: String,
                      completionHandler: @escaping ([Bars]?, Error?) -> Void) {
        
        let apikey = "0g0Mg9tmiapxosl3_LQ-mMgVi4l2pSd1fv6D9DHprV7gIGFNLYyvx_95EzIC6NATubQXGMLmLIfXUhtU_6kjpyVNFiYS7LLOCQ4TO30Ke4qz_a2hudBkJMSCbiWcYnYx"
        
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
        
        
        let url = URL(string: baseURL)
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                
                var barsList: [Bars] = []
                
                for business in businesses {
                    var bar = Bars()
                    bar.name = business.value(forKey: "name") as? String
                    bar.id = business.value(forKey: "id") as? String
                    bar.rating = business.value(forKey: "rating") as? Float
                    bar.price = business.value(forKey: "price") as? String
                    bar.is_closed = business.value(forKey: "is_closed") as? Bool
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    bar.address = address?.joined(separator: "\n")
                    bar.latitude = business.value(forKeyPath: "coordinates.latitude") as? Double
                    bar.longitude = business.value(forKeyPath: "coordinates.longitude") as? Double
                    bar.image_url = business.value(forKey: "image_url") as? String
                    bar.distance = business.value(forKey: "distance") as? Double
                    
                    barsList.append(bar)
                }
                
                completionHandler(barsList, nil)
            } catch {
                print("Caught error")
            }
        }.resume()
    }
}


extension BarViewController {
    func retrieveBarData(id: String,
                         completionHandler: @escaping (Bar?, Error?) -> Void) {
        
        let apikey = "0g0Mg9tmiapxosl3_LQ-mMgVi4l2pSd1fv6D9DHprV7gIGFNLYyvx_95EzIC6NATubQXGMLmLIfXUhtU_6kjpyVNFiYS7LLOCQ4TO30Ke4qz_a2hudBkJMSCbiWcYnYx"
        
        let baseURL = "https://api.yelp.com/v3/businesses/\(id)"
        
        let url = URL(string: baseURL)
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let hours = resp.value(forKey: "hours") as? [NSDictionary] else { return }
                
                var bar = Bar()
                
                bar.id = resp.value(forKey: "id") as? String
                bar.name = resp.value(forKey: "name") as? String
                bar.phone = resp.value(forKey: "display_phone") as? String
                let address = resp.value(forKeyPath: "location.display_address") as? [String]
                bar.address = address?.joined(separator: " ")
                bar.photos = (resp.value(forKey: "photos") as? [String])!
                bar.price = resp.value(forKey: "price") as? String
                bar.url = resp.value(forKey: "url") as? String
                bar.latitude = resp.value(forKeyPath: "coordinates.latitude") as? Double
                bar.longitude = resp.value(forKeyPath: "coordinates.longitude") as? Double
                
                for hour in hours {
                    bar.isOpen = hour.value(forKey: "is_open_now") as? Bool
                }

                
                completionHandler(bar, nil)
            } catch {
                print("Caught Error")
            }
        }.resume()
    }
}
