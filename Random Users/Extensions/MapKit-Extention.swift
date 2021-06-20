//
//  MapKit-Extention.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit
import MapKit


//MARK:- Open Map Navigation func
extension UIViewController {
    // enum Navigation Apps
    enum NavigationApps: String {
        case appleMaps = "Mappe"
        case googleMaps = "Google Maps"
    }
    
    // MARK: - Map Navigation
    func openMapForLocation(location: (latitude: Double, longitude: Double), locationName: String ) {
        let installedNavigationApps: [[String:String]] = [[NavigationApps.appleMaps.rawValue:""],[NavigationApps.googleMaps.rawValue:"comgooglemaps://"]]
        
        var alertAction: UIAlertAction?
        
        // actionSheet crash in ipad
        var preferredStyle: UIAlertController.Style
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredStyle = .alert
        }
        else{
            preferredStyle = .actionSheet
        }
        
        let attributedString = NSAttributedString(string: "Open in Maps" , attributes: [
            NSAttributedString.Key.font : bold(18),
            NSAttributedString.Key.foregroundColor : Config.darkBlue!
        ])
        
        //alert Title
        let alert = UIAlertController(title: "" , message: locationName , preferredStyle: preferredStyle)
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        for app in installedNavigationApps {
            let appName = app.keys.first
            if (appName == NavigationApps.appleMaps.rawValue || appName == NavigationApps.googleMaps.rawValue || UIApplication.shared.canOpenURL(URL(string:app[appName!]!)!)){
                alertAction = UIAlertAction(title: appName, style: .default, handler: { (action) in
                    
                    switch appName {
                    case NavigationApps.appleMaps.rawValue?:
                        let regionDistance: CLLocationDistance = 10000
                        let coordinates = CLLocationCoordinate2DMake( location.latitude, location.longitude)
                        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                        let options = [
                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                        ]
                        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                        let mapItem = MKMapItem(placemark: placemark)
                        
                        if locationName != "" {
                            mapItem.name = locationName
                        }
                        
                        mapItem.openInMaps(launchOptions: options)
                        break
                        
                    case NavigationApps.googleMaps.rawValue?:
                        if UIApplication.shared.canOpenURL(URL(string:app[appName!]!)!) {
                            //open in Google Maps application
                            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
                        } else {
                            //open in Browser
                            let string = "https://maps.google.com/?q=@\(location.latitude),\(location.longitude)"
                            UIApplication.shared.open(URL(string: string)!)
                        }
                        break
                    default:
                        break
                    }
                })
                alert.addAction(alertAction!)
            }else{
                print("Can't open URL scheme")
            }
        }
        alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertAction!)
        /*
         // Accessing alert view backgroundColor :
         alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Config.white
         // Accessing buttons tintcolor :
         alert.view.tintColor = Config.orange
         */
        self.present(alert, animated: true, completion: nil)
    }
}
