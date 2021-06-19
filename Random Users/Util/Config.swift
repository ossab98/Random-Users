//
//  Config.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit

class Config: NSObject {
    
    static let URL: String = "https://randomuser.me/api/"
    
    //MARK:- Custom colors
    static let darkBlue = UIColor(named: "darkBlue")
    static let darkGray = UIColor(named: "darkGray")
    static let gray = UIColor(named: "gray")
    static let orange = UIColor(named: "orange")
    static let white = UIColor(named: "white")
    
    //MARK:- Custom Size
    static let largeTitle : CGFloat = 30
    static let title : CGFloat = 25
    static let header : CGFloat = 20
    static let headline : CGFloat = 18
    static let body : CGFloat = 16
    static let subhead : CGFloat = 14
    static let cornerRadius: CGFloat = 10
    
    // To get an iPhone's device details
    static let deviceUdid = UIDevice.current.identifierForVendor?.uuidString // ABCDEF01-0123-ABCD-0123-ABCDEF012345
    static let deviceName = UIDevice.current.name // Name's iPhone
    static let deviceVersion = UIDevice.current.systemVersion // 14.5
    static let deviceModelName = UIDevice.current.model // iPhone
    static let deviceOsName = UIDevice.current.systemName // iOS
    static let deviceLocalized = UIDevice.current.localizedModel // iPhone
    
}

//MARK:- Custom Fonts
func regular(_ sizeFont: CGFloat)->UIFont {
    return UIFont(name: "Poppins-Regular", size: sizeFont)!
}
func medium(_ sizeFont: CGFloat)->UIFont {
    return UIFont(name: "Poppins-Medium", size: sizeFont)!
}
func semiBold(_ sizeFont: CGFloat)->UIFont {
    return UIFont(name: "Poppins-SemiBold", size: sizeFont)!
}
func bold(_ sizeFont: CGFloat)->UIFont {
    return UIFont(name: "Poppins-Bold", size: sizeFont)!
}
