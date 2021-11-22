//
//  APIService.swift
//  MVVM_New
//
//  Created by Abhilash Mathur on 20/05/20.
//  Copyright © 2020 Abhilash Mathur. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case badRequest = "Bad request"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
}


enum Result<String> {
    case success
    case failure(String)
}

class APIService :  NSObject {
    
    private let sourcesURL = "http://api.openweathermap.org/data/2.5/weather?lat="
    private let APIKey = "fae7190d7e6433ec3a45285ffcf55c86"
    
    func getWheatherData(withLong longID: String,LatIDString: String,callBack:@escaping(Bool, String?) ->()){
        
        let baseUrlString = String(format: "%@%@%@%@%@%@", sourcesURL,longID,"&lon=",LatIDString,"&appid=",APIKey)
        
        let createAccountURL = URL(string: baseUrlString)
        print(createAccountURL as Any)
        
        
        URLSession.shared.dataTask(with: createAccountURL!) { (data, urlResponse, error) in
            if error != nil {
                callBack(false, "Something went wrong")
            }
            if let response = urlResponse as? HTTPURLResponse {
                let result  =  self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        callBack(false, NetworkResponse.noData.rawValue)

                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        
//                         let apiResponse = try JSONDecoder().decode([Country].self, from: responseData)
                        
                        callBack(true, "")
                    }catch {
                        print(error)
                        callBack(false, "Something went wrong")
                    }
                    break
                case .failure(let networkFailureError):
                    callBack(false, networkFailureError)

                    break
                }
            }

            
        }.resume()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

}
