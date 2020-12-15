//
//  CollectionViewController.swift
//  myExtension
//
//  Created by Engin KUK on 14.12.2020.
//

import UIKit

@available(iOSApplicationExtension 13.0, *)

class ImgCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var imageSet: [UIImage] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let image = #imageLiteral(resourceName: "sampleImage.jpeg")
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.contents = image.cgImage
        return cell
    }

}
