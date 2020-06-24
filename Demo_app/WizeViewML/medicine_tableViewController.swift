//
//  medicine_tableViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/5/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit

class medicine_tableViewController: UIViewController, UITableViewDataSource {
    
    
    var result: [String] = []
    
    var field: [String] = ["Medication Name","Strength","Form","Quantity","Fill Date","Expiration Date"]
    
   

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! medicineTableViewCell
        
        let text = field[indexPath.row]
        let r = result[indexPath.row]
        
        cell.lbl_1?.text = text
        cell.lbl_2?.text = r
        
        return cell
    }
    
    

    
}
