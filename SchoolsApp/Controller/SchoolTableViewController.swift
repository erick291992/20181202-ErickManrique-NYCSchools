//
//  School.swift
//  SchoolsApp

import UIKit
import Alamofire
import CSV

class SchoolTableViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let cellId = String(describing: SchoolCell.self)
    var schools = [School]()
    var filteredSchools = [School]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
//        parseCSV()
//        swiftParser()
//        swiftParser2()
        requestSchools()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    // MARK: - parses the csv file to an array of school objects
//    func parseCSV(){
//        DispatchQueue.global(qos: .background).async {
//            guard let path = Bundle.main.path(forResource: Csv.schoolsInfoPath, ofType: Csv.fileType) else {
//                return
//            }
//
//            do{
//                let csv = try CSV(contentsOfURL: path)
//                let schools = csv.rows.map({
//                    return School(dictionary: $0)
//                })
//                DispatchQueue.main.async { [weak self] in
//                    self?.schools = schools
//                    self?.tableView.reloadData()
//                }
//            }catch{
//
//            }
//        }
//    }
    
//    func swiftParser(){
//
//        DispatchQueue.global(qos: .background).async {
//            guard let path = Bundle.main.path(forResource: Csv.schoolsInfoPath, ofType: Csv.fileType) else {
//                return
//            }
//            let stream = InputStream(fileAtPath: path)!
//            do {
//                let csv = try CSVReader(stream: stream, hasHeaderRow: true)
//                var schools = [School]()
//
//                while csv.next() != nil {
//                    schools.append(School(dictionary: csv))
//                }
//                DispatchQueue.main.async { [weak self] in
//                    self?.schools = schools
//                    self?.tableView.reloadData()
//                }
//            } catch {
//                print("error in swift parser",error)
//            }
//        }
//
//    }
    
//    func swiftParser2(){
//
//        DispatchQueue.global(qos: .background).async {
//            guard let path = Bundle.main.path(forResource: Csv.schoolsInfoPath, ofType: Csv.fileType) else {
//                return
//            }
//            let csvString: String?
//            do {
//                csvString = try String(contentsOfFile: path, encoding: .utf8)
//            } catch _ {
//                csvString = nil
//            };
//
//            guard csvString != nil else {
//                return
//            }
//
//            do {
//                let csv = try CSVReader(string: csvString!, hasHeaderRow: true)
//                var schools = [School]()
//
//                while csv.next() != nil {
//                    schools.append(School(dictionary: csv))
//                }
//                DispatchQueue.main.async { [weak self] in
//                    self?.schools = schools
//                    self?.tableView.reloadData()
//                }
//            } catch {
//                print("error in swift parser",error)
//            }
//        }
//
//    }
    
    func requestSchools(){
        Service.shared.getSchools { (schools, error) in
            if let error = error {
                print("error: \(String(describing: error))")
                
                return
            } else {
                if let schools = schools {
                    DispatchQueue.main.async { [weak self] in
                        self?.schools = schools
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredSchools = schools.filter({( school : School) -> Bool in
            return school.school_name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }

}

extension SchoolTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSchools.count
        }
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SchoolCell
        let school:School
        if isFiltering() {
            school = filteredSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        cell.nameLabel.text = school.school_name
        cell.addressLabel.text = school.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schoolViewController = SchoolViewController()
        let school:School
        if isFiltering() {
            school = filteredSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        schoolViewController.school = school
        navigationController?.pushViewController(schoolViewController, animated: true)
    }
}

extension SchoolTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
