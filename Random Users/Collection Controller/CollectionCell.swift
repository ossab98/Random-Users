//
//  CollectionCell.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    // MARK:- Outlets
    // Offer View
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPhoneBtn: UIButton!
    @IBOutlet weak var userEmailBtn: UIButton!
    @IBOutlet weak var userLocationBtn: UIButton!
    
    var collectionController: CollectionController!
    var user: Results!
    
    func setUpCell(){
        
        // Set backgroundColor
        backgroundColor = Config.darkBlue
        layer.masksToBounds = true
        layer.cornerRadius = Config.cornerRadius
        layer.borderWidth = 1
        
        // Set userPicture
        userPicture.layer.borderWidth = 1
        userPicture.layer.borderColor = Config.darkGray?.cgColor
        userPicture.layer.masksToBounds = true
        userPicture.layer.cornerRadius = Config.cornerRadius
        userPicture.contentMode = .scaleAspectFill
        if let url = URL(string: user.picture?.large ?? "" ){
            userPicture.sd_setImage(with: url, placeholderImage: UIImage(named: "place-holder"))
        }
        
        // Set userFullName
        userFullName.text = "\(user.name?.title ?? "") \(user.name?.first ?? "") \(user.name?.last ?? "")"
        userFullName.textColor = Config.white
        userFullName.font = medium(Config.headline)
        userFullName.numberOfLines = 2
        
        // Set userPhoneBtn
        userPhoneBtn.setImage(UIImage(systemName: "phone"), for: .normal)
        userPhoneBtn.tintColor = Config.orange
        userPhoneBtn.backgroundColor = Config.darkGray
        userPhoneBtn.layer.masksToBounds = true
        userPhoneBtn.layer.cornerRadius = Config.cornerRadius
        userPhoneBtn.addTarget(self, action: #selector(onCallPhoneTapped), for: .touchUpInside)
        
        // Set userEmailBtn
        userEmailBtn.setImage(UIImage(systemName: "mail"), for: .normal)
        userEmailBtn.tintColor = Config.orange
        userEmailBtn.backgroundColor = Config.darkGray
        userEmailBtn.layer.masksToBounds = true
        userEmailBtn.layer.cornerRadius = Config.cornerRadius
        userEmailBtn.addTarget(self, action: #selector(onSendEmailTapped), for: .touchUpInside)
        
        // Set userLocationBtn
        userLocationBtn.setImage(UIImage(systemName: "map"), for: .normal)
        userLocationBtn.tintColor = Config.orange
        userLocationBtn.backgroundColor = Config.darkGray
        userLocationBtn.layer.masksToBounds = true
        userLocationBtn.layer.cornerRadius = Config.cornerRadius
        userLocationBtn.addTarget(self, action: #selector(onOpenMapsTapped), for: .touchUpInside)
    }
    
}



// MARK:- Actions
extension CollectionCell{
    
    @objc func onCallPhoneTapped(sender: UIButton) {
        collectionController?.callPhone(number: user?.phone ?? "")
    }
    
    @objc func onSendEmailTapped(sender: UIButton) {
        
        let message = """
        \r\n\r\n\r\n\r\n
        This email created by 'Random Users App'r\n
                            * Device Details *
        User Name: \(Config.deviceName),
        Model: \(Config.deviceModelName),
        Version: \(Config.deviceVersion),
        System: \(Config.deviceOsName).
        \r\n
        Cordiali Saluti.
        Random Users User
        """
        
        collectionController?.sendEmail(user?.email ?? "", "Random Users App", message)
    }
    
    @objc func onOpenMapsTapped(sender: UIButton) {
        let lan = user?.location?.coordinates?.latitude ?? ""
        let lon = user?.location?.coordinates?.longitude ?? ""
        let location = "\(user.location?.street?.name ?? "") \(user.location?.street?.number ?? 0), \(user.location?.city ?? ""), \(user.location?.postcode ?? "") - \(user.location?.country ?? "")"
        collectionController?.openMapForLocation(location: (latitude: lan, longitude: lon), locationName: location)
    }
    
}

