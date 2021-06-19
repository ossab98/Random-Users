//
//  Connectivity.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
