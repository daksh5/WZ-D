//
//  tug_tableViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/6/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit

class tug_tableViewController: UIViewController, UITableViewDataSource {
  
    
    @IBOutlet weak var table: UITableView!
    
    var result: [Int] = []
    var field: [String] = ["Unable rise","Unable straighten","StS count"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        self.table.rowHeight = 100

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return field.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "t_cell")! as! tugTableViewCell
        
        var stringArray = result.map { String($0) }
        let text = field[indexPath.row]
        let r = stringArray[indexPath.row]
        
        cell.lbl_1?.text = text
        cell.lbl_2?.text = r
        
        return cell
    }
    

    

}
