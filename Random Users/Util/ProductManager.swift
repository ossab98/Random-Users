//
//  ProductManager.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 20/06/21.
//

import UIKit

class ProductManager {
    
    let networkHandler = NetworkHandler()
    
    func getRandomUsers(urlPath: String, onSuccess:((UserModel) -> ())?, onError: @escaping((Error?) -> ())){
        networkHandler.postData(urlPath: urlPath, method: .get, with: UserModel.self, parameters: .none) { [weak self](response) in
            guard let _ = self , let data = response else {return}
            onSuccess?(data)
            
        } returnError: { error in
            onError(error)
        }
    }
    
}
