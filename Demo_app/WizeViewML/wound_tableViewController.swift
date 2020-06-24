//
//  wound_tableViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/5/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit

class wound_tableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var result: [String] = []
    
    var field: [String] = ["Stage", "Eschar", "Slough", "PrimaryColor"]

    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        self.table.rowHeight = 100
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return field.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "w_cell")! as! woundTableViewCell
        
        let text = field[indexPath.row]
        let r = result[indexPath.row]
        
        cell.lbl_1?.text = text 
        cell.lbl_2?.text = r
        
        return cell
        
        
    }
   
}
