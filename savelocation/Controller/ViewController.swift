//
//  ViewController.swift
//  savelocation
//
//  Created by Deepika B on 04/08/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView : UITableView!
    var locations : [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    @objc func willEnterForeground() {
        locations = getLocations()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locations = getLocations()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func getLocations() -> [Location]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result as? [Location]
            
            
        } catch {
            
            print("Failed")
            return nil
        }
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.locationAdd.text = locations?[indexPath.row].currentlocation
        let date  = (locations?[indexPath.row].time)!
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let now = df.string(from: date)
        cell.timeLbl.text = now
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}
