//
//  UserDetailsController.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit

class UserDetailsController: UITableViewController {

    // MARK:- Outlets
    @IBOutlet weak var lblPersonalInfoHeader: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
    @IBOutlet weak var lblContactInfoHeader: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userCell: UILabel!
    
    @IBOutlet weak var lblOtherInfoHeader: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPassword: UILabel!
    @IBOutlet weak var userBirthday: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userRegisteredIn: UILabel!
    
    
    // MARK: - Properties / Models
    var user: Results!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Navigation Title
        navigationItem.title = "\(user?.name?.title ?? "") \(user?.name?.first ?? "")"
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - Table view data source
extension UserDetailsController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 15
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 3: // Location
            let lan = user?.location?.coordinates?.latitude ?? ""
            let lon = user?.location?.coordinates?.longitude ?? ""
            let location = "\(user.location?.street?.name ?? "") \(user.location?.street?.number ?? 0), \(user.location?.city ?? ""), \(user.location?.postcode ?? "") - \(user.location?.country ?? "")"
            openMapForLocation(location: (latitude: lan, longitude: lon), locationName: location)
            
        case 5: // Email
            let message = """
            \r\n\r\n\r\n\r\n
            This email created by 'Random Users App' \r\n
                                * Device Details *
            User Name: \(Config.deviceName),
            Model: \(Config.deviceModelName),
            Version: \(Config.deviceVersion),
            System: \(Config.deviceOsName).
            \r\n
            Cordiali Saluti.
            Random Users User
            """
            sendEmail(user?.email ?? "", "Random Users App", message)
            
        case 6: // Phone
            callPhone(number: user?.phone ?? "")
            
        case 7: // Cell
            callPhone(number: user?.cell ?? "")
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


// MARK:- SetUpView
extension UserDetailsController {
    
    func setUpView(){
        
        // Set backgroundColor View
        view.backgroundColor = Config.white
        
        // Set lblPersonalInfoHeader
        lblPersonalInfoHeader.text = "Personal Information".uppercased()
        lblPersonalInfoHeader.textColor = Config.darkBlue
        lblPersonalInfoHeader.font = bold(Config.header)
        lblPersonalInfoHeader.numberOfLines = 0
        
        // Set userPicture
        userPicture.contentMode = .scaleAspectFit
        userPicture.layer.masksToBounds = true
        userPicture.layer.cornerRadius = Config.cornerRadius
        if let url = URL(string: user.picture?.large ?? "" ){
            userPicture.sd_setImage(with: url, placeholderImage: UIImage(named: "place-holder"))
        }
        
        // Set userFullName
        userFullName.text = "\(user.name?.title ?? "") \(user.name?.first ?? "") \(user.name?.last ?? "")"
        userFullName.textColor = Config.darkBlue
        userFullName.font = semiBold(Config.header)
        userFullName.numberOfLines = 0
        
        // Set userLocation
        let location = "\(user.location?.street?.name ?? "") \(user.location?.street?.number ?? 0), \(user.location?.city ?? ""), \(user.location?.postcode ?? "") - \(user.location?.country ?? "")"
        userLocation.text = location
        userLocation.textColor = Config.darkGray
        userLocation.font = regular(Config.headline)
        userLocation.numberOfLines = 0
        
        // Set lblContactInfoHeader
        lblContactInfoHeader.text = "Contact Information".uppercased()
        lblContactInfoHeader.textColor = Config.darkBlue
        lblContactInfoHeader.font = bold(Config.header)
        lblContactInfoHeader.numberOfLines = 0
        
        // Set userEmail
        let email = NSMutableAttributedString()
        let btnAttrs1 = [NSAttributedString.Key.font : medium(Config.body), NSAttributedString.Key.foregroundColor : UIColor.white]
        let btnAttrs2 = [NSAttributedString.Key.font : regular(Config.body), NSAttributedString.Key.foregroundColor : UIColor.orange]
        email.append(NSAttributedString(string: "Send email to:\r\n", attributes: btnAttrs1 ));
        email.append(NSAttributedString(string: "\(user.email?.uppercased() ?? "")", attributes: btnAttrs2 ))
        userEmail.attributedText = email
        userEmail.backgroundColor = Config.darkGray
        userEmail.layer.masksToBounds = true
        userEmail.layer.cornerRadius = Config.cornerRadius
        userEmail.layer.borderWidth = 1
        userEmail.layer.borderColor = Config.darkGray?.cgColor
        
        // Set userPhone
        let phone = NSMutableAttributedString()
        phone.append(NSAttributedString(string: "Call phone to:\r\n", attributes: btnAttrs1 ));
        phone.append(NSAttributedString(string: "\(user.phone ?? "")", attributes: btnAttrs2 ))
        userPhone.attributedText = phone
        userPhone.backgroundColor = Config.darkGray
        userPhone.layer.masksToBounds = true
        userPhone.layer.cornerRadius = Config.cornerRadius
        userPhone.layer.borderWidth = 1
        userPhone.layer.borderColor = Config.darkGray?.cgColor
        userPhone.numberOfLines = 0
        
        // Set userCell
        let cell = NSMutableAttributedString()
        cell.append(NSAttributedString(string: "Call Cell to:\r\n", attributes: btnAttrs1 ));
        cell.append(NSAttributedString(string: "\(user.cell ?? "")", attributes: btnAttrs2 ))
        userCell.attributedText = cell
        userCell.backgroundColor = Config.darkGray
        userCell.layer.masksToBounds = true
        userCell.layer.cornerRadius = Config.cornerRadius
        userCell.layer.borderWidth = 1
        userCell.layer.borderColor = Config.darkGray?.cgColor
        userCell.numberOfLines = 0
        
        // Set lblOtherInfoHeader
        lblOtherInfoHeader.text = "Other Information".uppercased()
        lblOtherInfoHeader.textColor = Config.darkBlue
        lblOtherInfoHeader.font = bold(Config.header)
        lblOtherInfoHeader.numberOfLines = 0
        
        // Set userName
        let logName = NSMutableAttributedString()
        let attrs1 = [NSAttributedString.Key.font : semiBold(Config.headline), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : medium(Config.headline), NSAttributedString.Key.foregroundColor : UIColor.orange]
        logName.append(NSAttributedString(string: "Username:  ".uppercased(), attributes: attrs1 ));
        logName.append(NSAttributedString(string: "\(user.login?.username?.uppercased() ?? "")", attributes: attrs2 ))
        userName.attributedText = logName
        userName.contentMode = .left
        userName.numberOfLines = 0
        
        // Set userPassword
        let pass = NSMutableAttributedString()
        pass.append(NSAttributedString(string: "Password:  ".uppercased(), attributes: attrs1 ));
        pass.append(NSAttributedString(string: "\(user.login?.password ?? "")", attributes: attrs2 ))
        userPassword.attributedText = pass
        userPassword.contentMode = .left
        userPassword.numberOfLines = 0
        
        // Set userBirthday
        let birthdayString = "\(user.dob?.date?.prefix(10) ?? "")"
        let birthday = NSMutableAttributedString()
        birthday.append(NSAttributedString(string: "Birthday:  ".uppercased(), attributes: attrs1 ));
        birthday.append(NSAttributedString(string: "\(birthdayString)", attributes: attrs2 ))
        userBirthday.attributedText = birthday
        userBirthday.contentMode = .left
        userBirthday.numberOfLines = 0
        
        // Set userAge
        let age = NSMutableAttributedString()
        age.append(NSAttributedString(string: "Age:  ".uppercased(), attributes: attrs1 ));
        age.append(NSAttributedString(string: "+\(user.dob?.age ?? 0)  Years", attributes: attrs2 ))
        userAge.attributedText = age
        userAge.contentMode = .left
        userAge.numberOfLines = 0
        
        // Set userGender
        let gender = NSMutableAttributedString()
        gender.append(NSAttributedString(string: "Gender:  ".uppercased(), attributes: attrs1 ));
        gender.append(NSAttributedString(string: "\(user.gender ?? "")", attributes: attrs2 ))
        userGender.attributedText = gender
        userGender.contentMode = .left
        userGender.numberOfLines = 0
        
        // Set userRegisteredIn
        let registered = NSMutableAttributedString()
        registered.append(NSAttributedString(string: "Registerd:  ".uppercased(), attributes: attrs1 ));
        registered.append(NSAttributedString(string: "\(user.registered?.date?.prefix(10) ?? ""), From: \(user.registered?.age ?? 0) Years" , attributes: attrs2 ))
        userRegisteredIn.attributedText = registered
        userRegisteredIn.contentMode = .left
        userRegisteredIn.numberOfLines = 0
        
    }
   
}
