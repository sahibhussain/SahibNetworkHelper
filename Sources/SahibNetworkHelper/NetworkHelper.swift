//
//  NetworkHelper.swift
//  SahibHelper
//
//  Created by sahib hussain on 08/06/18.
//  Copyright © 2018 Burning Desire Inclusive. All rights reserved.
//

import UIKit
import Alamofire

public class NetworkHelper {
    
    public typealias CompletionHandler = (_ response: Result<[String: Any], Error>) -> Void
    public var headers: [String: String] = [:]
    public var baseURL: String = ""
    
    
    public static let shared = NetworkHelper()
    
    private init () {
        headers = ["Content-Type": "application/json"]
    }
    
    
    // MARK: - networkd related
    public func sendPostRequest(_ urlExt: String, param: [String: Any], comp: @escaping CompletionHandler) {
        
        let urlString = baseURL + urlExt
        
        AF.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: .init(headers))
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                    if let json = json {
                        comp(.success(json))
                    }else {
                        comp(.failure(CustomError.invalidData))
                    }
                case .failure(let error):
                    comp(.failure(error))
                }
            }
        
    }
    
    public func sendPostRequest(_ urlExt: String, param: [String: String], withFile: [String: URL], comp: @escaping CompletionHandler) {
        
        let urlString = baseURL + urlExt
        
        AF.upload(multipartFormData: { (formData) in
            
            for (key, value) in withFile {
                formData.append(value, withName: key)
            }
            
            for (key, value) in param {
                let data = value.data(using: .utf8)!
                formData.append(data, withName: key)
            }
            
        }, to: urlString, headers: HTTPHeaders(headers))
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                if let json = json {
                    comp(.success(json))
                }else {
                    comp(.failure(CustomError.invalidData))
                }
            case .failure(let error):
                comp(.failure(error))
            }
        })
        
    }
    
    
    public func sendGetRequest(_ urlExt: String, param: String, comp: @escaping CompletionHandler) {
        
        var urlString = baseURL + urlExt + "?" + param
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        AF.request(urlString, method: .get, headers: HTTPHeaders(headers))
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                    if let json = json {
                        comp(.success(json))
                    }else {
                        comp(.failure(CustomError.invalidData))
                    }
                case .failure(let error):
                    comp(.failure(error))
                }
            })
        
    }
    
    public func sendGetRequest(with completeUrl: String, param: String, comp: @escaping CompletionHandler) {
        
        var urlString = completeUrl + "?" + param
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        AF.request(urlString, method: .get, headers: HTTPHeaders(headers))
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                    if let json = json {
                        comp(.success(json))
                    }else {
                        comp(.failure(CustomError.invalidData))
                    }
                case .failure(let error):
                    comp(.failure(error))
                }
            })
        
    }
    
    
    public func sendRequest(_ urlExt: String, method: HTTPMethod, param: [String: Any], comp: @escaping CompletionHandler) {
        
        let urlString = baseURL + urlExt
        
        AF.request(urlString, method: method, parameters: param, encoding: JSONEncoding.default, headers: .init(headers))
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                    if let json = json {
                        comp(.success(json))
                    }else {
                        comp(.failure(CustomError.invalidData))
                    }
                case .failure(let error):
                    comp(.failure(error))
                }
            }
        
    }
    
    // MARK: - json related
    public func jsonToString(_ json: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {return nil}
        return String(data: data, encoding: .utf8)
    }
    
    
}

