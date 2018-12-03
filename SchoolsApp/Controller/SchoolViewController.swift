//
//  School.swift
//  SchoolsApp

import UIKit

class SchoolViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    
    var school:School!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let schoolScores = school.schoolsScores {
            self.mathLabel.text = schoolScores.sat_math_avg_score
            self.readingLabel.text = schoolScores.sat_critical_reading_avg_score
            self.writingLabel.text = schoolScores.sat_writing_avg_score
            requestPhoto(for: school.address)
        } else {
            requestSchores()
            requestPhoto(for: school.address)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestSchores(){
        Service.shared.getSchoolScores(dbn: school.dbn) { (schoolScores, error) in
            DispatchQueue.main.async { [weak self] in
                self?.school.schoolsScores = schoolScores
                self?.mathLabel.text = self?.school.schoolsScores?.sat_math_avg_score
                self?.readingLabel.text = self?.school.schoolsScores?.sat_critical_reading_avg_score
                self?.writingLabel.text = self?.school.schoolsScores?.sat_writing_avg_score
            }
        }
    }
    
    func requestPhoto(for address:String){
        print(address)
        Service.shared.getFirstPhotoForPlace(address: address) { (image, error) in
            if let error = error {
                print("error: \(String(describing: error))")
                
                return
            } else {
                if let googleImage = image {
                    print("we are getting image")
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = googleImage
                    }
                } else {
                    return
                }
                
            }
        }
    }

}
