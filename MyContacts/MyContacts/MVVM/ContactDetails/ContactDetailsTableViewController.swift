//
//  ContactDetailsTableViewController.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/23/21.
//

import UIKit

class ContactDetailsTableViewController: UITableViewController {

    var viewModel:ContactDetailsViewModel!
    var identifier:String?
    var dataSource:TableViewDataSource!
    
    // MARK: Override methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNotifications()
        configureTableView()
        getContactDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private methods
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contactChanged),
                                               name: NSNotification.Name.CNContactStoreDidChange,
                                               object: nil)
    }
    
    @objc
    func contactChanged() {
        
        getContactDetails()
    }
    
    private func configureTableView() {
        
        let configureCell:(TableViewCellBlock) = {cell, item in
            cell.configureCell(item: item)
        }
        dataSource = TableViewDataSource(configureCellBlock: configureCell)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func getContactDetails() {
        
        if(identifier != nil) {
            
            viewModel = ContactDetailsViewModel()
            viewModel.getContactDetailsWithIdentifier(identifier!)
            viewModel.bindViewModelToController =  {
                self.updateDataSource()
            }
        } else {
            let alertController = UIAlertController(title: "Error",
                                                    message: "The contact not found",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default,handler: { action in }))
        }
    }
    
    // Refresh table view
    private func updateDataSource(){
            
        DispatchQueue.main.async {
            self.dataSource.items = self.viewModel.contactDetails
            self.tableView.reloadData()
        }
    }
}
