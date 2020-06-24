//
//  tug_error_tableViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/11/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit

class tug_error_tableViewController: UIViewController, UITableViewDataSource {
    
    var field: [String] = ["Message", " Status Code", "Error"]
    var error: [String] = []

    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        self.table.rowHeight = 100

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return field.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "e_t_cell")! as! tug_errorTableViewCell
        
        let text = field[indexPath.row]
        let r = error[indexPath.row]
        
        cell.lbl_1?.text = text
        cell.lbl_2?.text = r
        
        return cell
        
    }
    

    

}
