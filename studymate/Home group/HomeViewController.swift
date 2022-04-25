//
//  HomeViewController.swift
//  studymate
//
//  Created by Tahamid on 4/23/22.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var profileArray = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        getAPIData()
    }
    
    
    @objc func getAPIData() {
        let query = PFQuery(className: "_User")
        query.includeKeys(["objectId"])
//        query.limit = 20

        query.findObjectsInBackground{(profiles, error) in
            if profiles != nil {
                self.profileArray = profiles!
                self.tableView.reloadData()
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchViewCell") as! MatchViewCell
        let profile = profileArray[indexPath.row]
        
        cell.classYearLabel.text = profile["year"] as? String
        cell.nameLabel.text = profile["username"] as? String
        cell.majorLabel.text = profile["major"] as? String
        cell.bioLabel.text = profile["bio"] as? String
        let imageFile = profile["image"] as! PFFileObject
        let urlString = imageFile.url!
        let URL = URL(string: urlString)!
        
        
        cell.profileView.af.setImage(withURL: URL)
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
