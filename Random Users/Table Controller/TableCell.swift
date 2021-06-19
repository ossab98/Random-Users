//
//  TableCell.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit
import SDWebImage


class TableCell: UITableViewCell {

    // MARK:- Outlets
    // Offer View
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var imgIsGreaterThan: UIImageView!
    
    func setUpCell(user: Results){
        
        // Set backgroundColor
        contentView.backgroundColor = Config.darkBlue
        
        // Set userPicture
        userPicture.contentMode = .scaleAspectFit
        userPicture.layer.masksToBounds = true
        userPicture.layer.cornerRadius = Config.cornerRadius
        if let url = URL(string: user.picture?.large ?? "" ){
            userPicture.sd_setImage(with: url, placeholderImage: UIImage(named: "place-holder"))
        }
        
        // Set userFullName
        userFullName.text = "\(user.name?.title ?? "") \(user.name?.first ?? "") \(user.name?.last ?? "")"
        userFullName.textColor = Config.white
        userFullName.font = medium(Config.headline)
        userFullName.numberOfLines = 1
        
        // Set userLocation
        let location = "\(user.location?.street?.name ?? "") \(user.location?.street?.number ?? 0), \(user.location?.city ?? ""), \(user.location?.postcode ?? "") - \(user.location?.country ?? "")"
        userLocation.text = location
        userLocation.textColor = Config.gray
        userLocation.font = medium(Config.body)
        userLocation.numberOfLines = 1
        
        // Set userPhone
        userPhone.text = user.phone ?? ""
        userPhone.textColor = Config.white
        userPhone.font = medium(Config.body)
        userPhone.numberOfLines = 1
        
        // Set imgIsGreaterThan
        imgIsGreaterThan.image = UIImage(named: "is-greater-than-icon")
        imgIsGreaterThan.contentMode = .scaleAspectFill
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
