//
//  APIRouter.swift
//  AlamofireInterceptor
//
//  Created by Anoop M on 2019-05-06.
//  Copyright © 2019 anoop. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPHeaderFields: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case requestName     = "RequestName"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestNames: String{
    case authenticateUser
    case fetchData
}
public enum APIRouter: URLRequestConvertible {
    
    static let baseURL = "BaseURL"
    
    // authentiacte user
    case authenticateUser([String: Any])
    case fetchData(String)

    // The http method to be used
    var method: HTTPMethod {
        switch self {
        case .authenticateUser:
            return .post
        case .fetchData:
            return .get
        }
    }
    // path of the request
    var path: String {
        switch self {
        case .authenticateUser:
            return "/oauth/authenticateUser"
        case .fetchData :
            return "/api/fetchData"
        }
    }
    
    var authheader: String {
        
        switch self {
        case .authenticateUser:
            return ""
        case .fetchData(let token):
            return "Bearer \(token)"
        }
    }
    var requestName: String {
        
        switch self {
        case .authenticateUser:
            return RequestNames.authenticateUser.rawValue
        case .fetchData:
            return RequestNames.fetchData.rawValue
        }
    }
    
    var encoding: ParameterEncoding {
        
        switch self {
        case .fetchData:
            return JSONEncoding.default
        case .authenticateUser:
            return URLEncoding.default
        }
    }
        
    public func asURLRequest() throws -> URLRequest {
        let param: [String: Any]? = {
            switch self {
            case .authenticateUser(let credentials):
                return credentials
            case .fetchData:
                return nil
            }
        }()
        let url = try APIRouter.baseURL.asURL()
        let finalPath = path
        var request = URLRequest(url: url.appendingPathComponent(finalPath))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        // Get the header data
        request.addValue(getAuthorizationHeader(), forHTTPHeaderField: HTTPHeaderFields.authentication.rawValue)
        request.addValue(getRequestNameHeader(), forHTTPHeaderField: HTTPHeaderFields.requestName.rawValue)

        return try encoding.encode(request, with: param)
    }
    
    private func getAuthorizationHeader() -> String {
        let header = authheader
        return header
    }
    
    private func getRequestNameHeader() -> String {
        let header = requestName
        return header
    }
}
