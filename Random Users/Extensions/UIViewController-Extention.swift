//
//  String-Extention.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit

// Call Phone
extension UIViewController {
    func callPhone(number: String) {
        if let url = URL(string: "tel://\(number.removeWhitespace())"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            alert(title: "Sorry!", message: "Cannot call this number!" , preferredStyle: .alert) { _ in }
        }
    }
    
    /*
     // Using
     makePhoneCall(phoneNumber: "\(3809066356)")
     */
}

// Send Email
import MessageUI
extension UIViewController: MFMailComposeViewControllerDelegate{
    
    func sendEmail(_ Email: String, _ Subject: String, _ Message: String){
        if MFMailComposeViewController.canSendMail(){
            let mail = MFMailComposeViewController()
            mail.setToRecipients([Email])
            mail.setSubject(Subject)
            mail.setMessageBody(Message, isHTML: false)
            mail.mailComposeDelegate = self
            
            if let filePath = Bundle.main.path(forResource: "sampleData", ofType: "json") {
                if let data = NSData(contentsOfFile: filePath) {
                    mail.addAttachmentData(data as Data, mimeType: "application/json" , fileName: "sampleData.json")
                }
            }
            present(mail, animated: true)
            
        }else{
            print("Email cannot be sent")
        }
    }
    
    // didFinishWith mail
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            self.dismiss(animated: true, completion: nil)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
            break
        case .sent:
            print("Mail sent successfully")
            break
        case .failed:
            print("Sending mail failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    /*
     Usaing
     sendEmail("ossab98@gmail.com", " ", " ")
     */
}
