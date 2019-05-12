//
//  AuthManager.swift
//  AlamofireInterceptor
//
//  Created by Anoop M on 2019-05-11.
//  Copyright © 2019 anoop. All rights reserved.
//

import Foundation

class AuthManager {
    
    private let networkManager: NetworkManager!
    init() {
        self.networkManager = NetworkManager.shared()
    }
    
    // Reauthenticate
    func authenticateUserWith(completion: @escaping (Result<String, Error?>) -> Void) {
        
        let credentials = [String: Any]() // Fetch these information from the credential storage either you may have saved in coredata or keychain
        networkManager.executeWith(request: APIRouter.authenticateUser(credentials)) { (result) in
            
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                do {
                    // Decode data and save the new token here
                    
                } catch(let error) {
                    completion(.error(error))
                }
            case .error(let error):
                   completion(.error(error))
            }

        }
    }
}
