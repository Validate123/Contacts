//
//  TableViewDataSource.swift
//  MyContacts
//
//  Created by Karen Petrosyan on 11/22/21.
//

import UIKit

typealias TableViewCellBlock = (_ cell : BaseTableViewCell, _ id:BaseModel) -> ()

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var arraySections:[[BaseModel]] = []
    var items:[BaseModel]!
    var configureCellBlock:TableViewCellBlock = {_,_ in }
    
    init(configureCellBlock: @escaping TableViewCellBlock)  {
        
        super.init()
        self.configureCellBlock = configureCellBlock
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arraySections.count > 0 ? arraySections.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(items != nil) {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item:BaseModel = items[indexPath.row]
        if(item.cellIdentifier != nil) {
            let cell:BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier!, for: indexPath) as! BaseTableViewCell
            configureCellBlock(cell, item)
            return cell
        }
        return UITableViewCell()
    }
}
