//
//  ServiceAPI.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 26/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit
import Alamofire

struct RequestConfig {
    var url : String
    var method : HTTPMethod
    var parameters : Parameters? = nil
    var encoding : ParameterEncoding = URLEncoding.default
    var headers : HTTPHeaders? = nil
}

extension RequestConfig {
    
    init(url: String, method: HTTPMethod, parameters : Parameters? = nil, headers : HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
    
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()
    static var isConnectedToInternet : Bool? {
        return self.sharedInstance?.isReachable
    }
}

class ServiceAPI: NSObject {
    
    @discardableResult
    class func request(config: RequestConfig, success: @escaping ((_ result : String?) -> Void),
                       failure: @escaping ((_ error : Error?, _ errorMessage: String) -> Void)) -> Request {
        
        if let hasConnection = Connectivity.isConnectedToInternet, !hasConnection {
            failure(nil, "no internet connection")
        }
        
        let request = Alamofire.request(config.url,
                                        method: config.method,
                                        parameters: config.parameters,
                                        encoding: config.encoding,
                                        headers: config.headers)
            .responseString { (response) in
                switch response.result {
                case .success: success(response.value)
                case .failure(let error): failure(error, error.localizedDescription)
                }
        }
        return request
    }
}
