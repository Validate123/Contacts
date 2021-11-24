//
//  ContactsViewController.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/22/21.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel:ContactsViewModel!
    var dataSource:TableViewDataSource!
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: Override methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNotifications()
        configurSegmentControl()
        configureSearchController()
        configureTableView()
        getContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "Contact-ContactDetails") {
         
            let vc:ContactDetailsTableViewController = segue.destination as! ContactDetailsTableViewController
            vc.identifier = sender as? String
        }
    }
    
    // MARK: View configurations
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contactsChanged),
                                               name: NSNotification.Name.CNContactStoreDidChange,
                                               object: nil)
    }
    
    @objc
    func contactsChanged() {
        
        getContacts()
    }
    
    private func configurSegmentControl() {
        
        let contactOrderType:ContactOrderType = Utility.getContactsOrderType()
        segmentControl.selectedSegmentIndex = contactOrderType.rawValue
    }
    
    private func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        
        let configureCell:(TableViewCellBlock) = {cell, item in
            cell.configureCell(item: item)
        }
        dataSource = TableViewDataSource(configureCellBlock: configureCell)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    // MARK: Working with data
    // Get contact from device contact list
    private func getContacts() {
        
        viewModel = ContactsViewModel()
        viewModel.getContacts()
        viewModel.bindViewModelToController =  {
            self.refreshData()
        }
    }
    
    // Refresh table view
    private func refreshData(){
            
        DispatchQueue.main.async {
            self.dataSource.items = self.viewModel.contacts
            self.tableView.reloadData()
        }
    }
    
    // MARK: Action methods
    @IBAction func onClickSegment(_ sender: Any) {
        
        if(ContactOrderType(rawValue: segmentControl.selectedSegmentIndex) != nil) {
            viewModel.setContactOrderType(ContactOrderType(rawValue: segmentControl.selectedSegmentIndex)!)
        }
    }
}

// MARK: UISearchResultsUpdating methods
extension ContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    
        let searchBar = searchController.searchBar
        if(isSearchBarEmpty) {
            dataSource.items = viewModel.contacts
        } else {
            dataSource.items = viewModel.filterContactsWithSearchText(searchBar.text!)
        }
        tableView.reloadData()
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelContact:ContactModel = dataSource.items[indexPath.row] as! ContactModel
        performSegue(withIdentifier: "Contact-ContactDetails", sender: modelContact.identifier)
    }
}
