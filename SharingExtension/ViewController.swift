//
//  ViewController.swift
//  SharingExtension
//
//  Created by Engin KUK on 10.12.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var importedElements: [UIImage] = []

     

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Imported elements"
        loadImportedItems()
        tableView.reloadData()
    }
    
     func loadImportedItems() {
            let savedata =  UserDefaults.init(suiteName: "group.engin.SharingExtension")
            print("ImageData \(String(describing: savedata?.value(forKey: "img")))")
            if savedata?.value(forKey: "img") != nil {
                print("Available Data")
                let data = ((savedata?.value(forKey: "img")as! NSDictionary).value(forKey: "imgData")as! Data)
                let str = ((savedata?.value(forKey: "img")as! NSDictionary).value(forKey: "name")as! String)
                let image = UIImage(data: data)
                importedElements.append(image!)
           }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        importedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! TableViewCell
        // text or image

        cell.myImageView.image = importedElements[indexPath.row]
        
        return cell
    }
   
     
}

