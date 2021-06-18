//
//  HomeController.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit

class HomeController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var btnTable: UIButton!
    @IBOutlet weak var btnCollection: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Navigation Title & backgroundColor
        navigationItem.title = "Select an design"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = Config.darkBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: semiBold(Config.title),
        NSAttributedString.Key.foregroundColor : Config.white!]
    }

}


// MARK:- Actions
extension HomeController {
    
    @IBAction func onTableTapped(_ sender: UIButton) {
        print("onTableTapped")
    }
    
    @IBAction func onCollectionTapped(_ sender: UIButton) {
        print("onCollectionTapped")
    }
    
}


// MARK:- SetUpView
extension HomeController {
    
    func setUpView(){
        
        // Set backgroundColor View
        view.backgroundColor = Config.darkBlue
        
        // Set btnTable
        btnTable.setTitle("TABLE".uppercased(), for: .normal)
        btnTable.titleLabel?.font = semiBold(Config.largeTitle)
        btnTable.setTitleColor(Config.orange, for: .normal)
        btnTable.backgroundColor = Config.darkBlue
        
        // Set btnCollection
        btnCollection.setTitle("COLLECTION".uppercased(), for: .normal)
        btnCollection.titleLabel?.font = semiBold(Config.largeTitle)
        btnCollection.setTitleColor(Config.orange, for: .normal)
        btnCollection.backgroundColor = Config.darkGray
        
    }
    
}
