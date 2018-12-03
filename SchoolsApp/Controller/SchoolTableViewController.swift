//
//  SchoolsViewController.swift
//  SchoolsApp
//
//  Created by Erick Manrique on 3/14/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import UIKit
import Alamofire

class SchoolsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellId = String(describing: SchoolCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
//        parseCSV()

        Service.shared.getFirstPhotoForPlace(address: "1600 Amphitheatre Pkwy, Mountain View") { (image, error) in
            if let error = error {
                return
            } else {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    // MARK: - formats the csv file to an array of data
    func parseCSV(){
        guard let path = Bundle.main.path(forResource: "2017_DOE_High_School_Directory", ofType: "csv") else {
            return
        }
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.headers
            for row in rows{
//                let dbn = row["school_name"]
//                print(dbn!)
                print(row)
            }
        }catch{
            
        }
    }

}

extension SchoolsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SchoolCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
