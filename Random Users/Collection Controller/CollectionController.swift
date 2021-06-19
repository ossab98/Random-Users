//
//  CollectionController.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit

class CollectionController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Outlets
    // CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    // Search View
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    
    
    // MARK: - Properties / Models
    let networkHandler = NetworkHandler()
    var info: Info!
    var results: [Results] = []
    
    // refresh
    var refreshControl = UIRefreshControl()
    
    // Pagination variables
    var page: Int = 1
    var per_page: Int = 10
    var isLimit: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setUpView()
        refreshCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Navigation Title
        navigationItem.title = "Collection"
        navigationItem.backButtonTitle = " "
    }
    
}


//MARK:- extension UITableViewDelegate && UITableViewDataSource
extension CollectionController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySorted().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        
        cell.collectionController = self
        cell.user = arraySorted()[indexPath.row]
        cell.setUpCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        // Push To UserDetailsController
        let UserDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userDetailsController") as! UserDetailsController
        UserDetailsVC.user = arraySorted()[indexPath.row]
        self.navigationController?.pushViewController(UserDetailsVC, animated: true)
    }
    
    //MARK:- Pagination to get new data
    
    // Hide NavigationBar when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
    // scrollViewDidEndDragging
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if !decelerate{
            scrolledToBottom(scrollView)
        }
    }
    
    // scrolledToBottom
    private func scrolledToBottom(_ scrollview:UIScrollView){
        let bottomEdge = scrollview.contentOffset.y + scrollview.frame.size.height
        if bottomEdge >= scrollview.contentSize.height{
            loadMoreData()
        }
    }
    
    // scrollViewDidEndDecelerating
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        scrolledToBottom(scrollView)
    }
    
    // Func to get new items when scrolling
    public func loadMoreData() {
        if isLimit == true {
            return
        }else{
            page = page + 1
            self.getData()
        }
    }
    
    
}


// MARK: - Func Helper
extension CollectionController {
    
    // To rest Data
    func restData(){
        // Remove all data
        self.results.removeAll()
        // Rest Pagination
        self.page = 1
        self.isLimit = false
    }
    
    // Reload the CollectionView
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.updateEmptyState(rowsCount: self.arraySorted().count, emptyMessage: "No data found!")
            self.collectionView.reloadData()
        }
    }
    
    // refresh
    func refreshCollectionView(){
        refreshControl.attributedTitle = NSAttributedString(string: "Reload",
                                                            attributes: [NSAttributedString.Key.foregroundColor: Config.orange!])
        refreshControl.tintColor = Config.orange
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    // Poll to refresh
    @objc func refresh(_ sender: AnyObject) {
        // Clear Data
        self.restData()
        // Reload View
        self.reloadCollectionView()
        // Get new data
        self.getData()
        // End Refreshing
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.refreshControl.endRefreshing()
        }
        
    }
    
    // Call API to get Data
    func getData(){
        DispatchQueue.main.async {
            if Connectivity.isConnectedToInternet() {
                self.callAPI()
            }else{
                self.alert(title: "Error", message: "Not connected to the internet. Please check your internet connection.", preferredStyle: .alert) {_ in
                    self.reloadCollectionView()
                }
            }
        }
    }
    
    func callAPI(){
        
        DispatchQueue.main.async {
            // Strat animation
            self.view.startLoading()
        }
        
        // call API
        let path = "?page=\(self.page)&results=\(per_page)"
        networkHandler.postData(urlPath: path, method: .get, with: UserModel.self , parameters: .none, returnWithData: {[weak self](response) in
            
            DispatchQueue.main.async {
                // Stop animation
                self?.view.stopLoading()
            }
            
            guard let self = self , let data = response else {return}
            
            // MARK:- If you want infinity pagination you can replace "self.page >= 10" To "data.results?.count ?? 0 < self.per_page" to get a  infinity users..
            // infinity pagination / max 100 users
            if self.page >= 10 {
                // There are no other data! Stop pagination
                self.isLimit = true
            }else{
                // Append new data
                self.results.append(contentsOf: data.results ?? [])
                self.info = data.info
            }
            
            // Reload View
            self.reloadCollectionView()
            
        }, returnError: {[weak self](error) in
            self?.view.stopLoading()
            // Show error message
            self?.alert(title: "Error", message: error?.localizedDescription ?? "Ops, something went wrong try again later.", preferredStyle: .alert, completion:{_ in})
        })
    }
    
}






//MARK:- Search
extension CollectionController {
    // Function to filter Array by...
    func arraySorted() -> [Results] {
        if searchField.text == "" {
            return results
        }else{
            return results.filter({
                $0.gender?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.name?.first?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.name?.last?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.street?.name?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.city?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.state?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.country?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.email?.uppercased().contains(searchField.text!.uppercased()) ?? false
            })
        }
    }
    
    // Reload tableView when writing
    @IBAction func searchTextField(_ sender: UITextField) {
        reloadCollectionView()
    }
    
    // Reload tableView when cancell all text
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchField.text = ""
        reloadCollectionView()
        return false
    }
    
    // Reload tableView when click "Search" on Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchField.returnKeyType = .search
        reloadCollectionView()
        return true
    }
    
    // textFieldDidBeginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reloadCollectionView()
    }
}


// MARK:- SetUpView
extension CollectionController {
    
    func setUpView(){
        // Set backgroundColor View
        view.backgroundColor = Config.darkBlue
        
        // Set collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        if let sliderFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            sliderFlowLayout.itemSize = CGSize(width: (screenWidth - 16) / 2, height: 300)
            sliderFlowLayout.minimumLineSpacing = 4
            sliderFlowLayout.minimumInteritemSpacing = 4
            sliderFlowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 25, right: 6)
        }
        
        // Set Search View
        searchView.backgroundColor = Config.darkGray
        searchView.layer.masksToBounds = true
        searchView.layer.cornerRadius = Config.cornerRadius
        
        // Set Search image
        searchImg.image = UIImage(named: "search")
        searchImg.contentMode = .scaleAspectFill
        
        // Set Search Field
        searchField.delegate = self
        searchField.textColor = Config.gray
        searchField.font = medium(Config.body)
        searchField.attributedPlaceholder = NSAttributedString(string: "Search",
        attributes: [NSAttributedString.Key.foregroundColor: Config.gray ?? .gray ])
        
    }
    
}
