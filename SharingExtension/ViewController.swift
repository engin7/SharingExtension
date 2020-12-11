//
//  ViewController.swift
//  SharingExtension
//
//  Created by Engin KUK on 10.12.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var importedElements: [[String : Any]] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Imported elements"

    }
    
     override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        loadImportedItems()
    }
    
       func loadImportedItems() {
            let loadData = UserDefaults.init(suiteName: "group.engin.SharingExtension")
            if loadData?.value(forKey: "imported") != nil {
                print("Available Data")
                importedElements = loadData?.value(forKey: "imported") as! [[String : Any]]
           }
        tableView.reloadData()
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        importedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! TableViewCell
        let importedElement = importedElements[indexPath.row] as NSDictionary
        
        // text or image

        if (importedElement["text"] != nil)  {
            cell.myImageView.image = UIImage()
            cell.myLabel.text = importedElement.value(forKey: "text")as? String
        } else {
            let imageData = importedElement.value(forKey: "imageData")as! Data
            cell.myLabel.text = importedElement.value(forKey: "imageText")as? String
            cell.myImageView.image = UIImage(data: imageData)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}

