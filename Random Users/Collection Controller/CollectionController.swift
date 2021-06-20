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
    
    private let lblCurrentPage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Config.orange
        label.textColor = Config.darkGray
        label.font = medium(Config.subhead)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        return label
    }()
    
    
    // MARK: - Properties / Models
    let productManager = ProductManager()
    var info: Info!
    var results: [Results] = []
    
    // refresh
    var refreshControl = UIRefreshControl()
    
    // Pagination variables
    var page: Int = 1
    var per_page: Int = 25
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentPage: Int = (indexPath.row / per_page) + 1
        lblCurrentPage.text = "Page: \(currentPage.description)"
    }
    
}


//MARK:- Pagination to get new data - UIScrollView
extension CollectionController {
    
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
    func reloadView(){
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
        self.reloadView()
        // Get new data
        self.getData()
        // End Refreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.refreshControl.endRefreshing()
        }
    }
    
    // Call API to get Data
    func getData(){
        DispatchQueue.main.async {
            if Connectivity.isConnectedToInternet() {
                self.callAPI()
            }else{
                self.alert(title: "Sorry!", message: "Not connected to the internet. Please check your internet connection.", preferredStyle: .alert) {_ in
                    self.reloadView()
                }
            }
        }
    }
    
    func callAPI(){
        
        DispatchQueue.main.async {
            // Strat animation
            self.view.startLoading()
        }
        
        productManager.getRandomUsers(urlPath: "?page=\(self.page)&results=\(per_page)") {[weak self](response) in
            DispatchQueue.main.async {
                // Strat animation
                self?.view.stopLoading()
            }
            
            guard let self = self else {return}
            let data = response
            
            // MARK:- If you want infinity pagination you can replace "self.page >= 5" To "data.results?.count ?? 0 < self.per_page" to get a  infinity users..
            // infinity pagination / max 100 users
            if self.page >= 5 {
                // There are no other data! Stop pagination
                self.isLimit = true
            }else{
                // Append new data
                self.results.append(contentsOf: data.results ?? [])
                self.info = data.info
            }
            
            // Reload View
            self.reloadView()
            
        } onError: { [weak self](error) in
            self?.view.stopLoading()
            // Show error message
            self?.alert(title: "Error", message: error?.localizedDescription ?? "Ops, something went wrong try again later.", preferredStyle: .alert, completion:{ _ in })
        }
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
                $0.name?.title?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.name?.first?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.name?.last?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.street?.name?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.city?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.state?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.country?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.location?.timezone?.description?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.email?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.login?.username?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.phone?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.cell?.uppercased().contains(searchField.text!.uppercased()) ?? false ||
                $0.nat?.uppercased().contains(searchField.text!.uppercased()) ?? false
            })
        }
    }
    
    // Reload tableView when writing
    @IBAction func searchTextField(_ sender: UITextField) {
        reloadView()
    }
    
    // Reload tableView when cancell all text
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchField.text = ""
        reloadView()
        return false
    }
    
    // Reload tableView when click "Search" on Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchField.returnKeyType = .search
        reloadView()
        return true
    }
    
    // textFieldDidBeginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reloadView()
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
        // add a bottom margin to collectionView
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        // Declare number of cells you want per row - Dynamic cells
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            var numberOfCellsPerRow: CGFloat = 2 // As a default
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                if flowLayout.scrollDirection == .vertical {
                    numberOfCellsPerRow = 2
                }else{
                    numberOfCellsPerRow = 4
                }
                
            case .pad:
                numberOfCellsPerRow = 4
                
            default:
                numberOfCellsPerRow = 2
            }
            
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: 300 /*'cellWidth' if you want be a dynamic*/)
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
        searchField.attributedPlaceholder = NSAttributedString(string: "Search...",
        attributes: [NSAttributedString.Key.foregroundColor: Config.gray ?? .gray ])
        
        // Set lblCurrentPage
        view.addSubview(lblCurrentPage)
        lblCurrentPage.layer.masksToBounds = true
        lblCurrentPage.layer.cornerRadius = Config.cornerRadius
        lblCurrentPage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        lblCurrentPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        lblCurrentPage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lblCurrentPage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
}
