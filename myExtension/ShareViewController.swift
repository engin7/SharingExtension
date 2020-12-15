import UIKit
 

 
class ShareViewController: UIViewController {
    
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aspectRatio: NSLayoutConstraint!

    var textDict: [String : Any] = ["text" : "placeholder"]
    var imgDictArray: [[String : Any]] = []

    
    private var ratio: CGFloat = 1
    var imageType = ""
    var textType = "public.text"
    var urlType = "public.url"
    var importedImages: [UIImage] = []
    
    var savedata = UserDefaults.init(suiteName: "group.engin.SharingExtension")
    
    // computed property
    var importedElementsArray: [[String : Any]] {
        get {
            return savedata?.value(forKey: "imported") as? [[String : Any]] ?? []
        }
        set {
            savedata?.set(newValue, forKey: "imported")
            savedata?.synchronize()
        }
    }
 
    
        override func viewDidLoad() {
            super.viewDidLoad()
            setUpContainerViews()
            
        }
     
    
    func setUpContainerViews() {
        
        textContainerView.isHidden = true
        textContainerView.layer.cornerRadius = 15
        textContainerView.layer.masksToBounds = true
        
        imageContainerView.layer.cornerRadius = 15
        imageContainerView.layer.masksToBounds = true
         
    }
     
    override func viewWillAppear(_ animated: Bool) {
      
        sharingPost { [self] in
            // reload
              
            let imageVC : ImgCollectionViewController = self.children[0].children[0] as! ImgCollectionViewController
            imageVC.imageSet = importedImages
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                imageVC.collectionView.reloadData()
            }

        }
    }
    
    
    func processText(itemProvider: NSItemProvider) {
         
        let textVC : TextViewController = self.children[1].children[0] as! TextViewController
 
        if itemProvider.hasItemConformingToTypeIdentifier(urlType) || itemProvider.hasItemConformingToTypeIdentifier(textType) {
            DispatchQueue.main.async { [self] in
            textContainerView.isHidden = false
            imageContainerView.isHidden = true
                
            }
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(textType) {

                print("importing text")

            itemProvider.loadItem(forTypeIdentifier: textType, options: nil, completionHandler: { [self] (item, error) in

                    print("Text item ===\(item)")

                DispatchQueue.main.async {
                textVC.textView.text = item as? String
                textVC.textView.textColor = .black
                textVC.textView.reloadInputViews()
                }
                
                textDict = ["text" :  item]
 
                })
        } else if itemProvider.hasItemConformingToTypeIdentifier(urlType) {

            itemProvider.loadItem(forTypeIdentifier: urlType, options: nil, completionHandler: { [self] (item, error) in

                let urlItem = item as! URL
                let urlItemString = urlItem.absoluteString

                print("URL item ===\(item)")
                
                DispatchQueue.main.async {
                textVC.textView.textColor = .blue
                textVC.textView.text = urlItemString
                textVC.textView.reloadInputViews()
                }
                
                textDict = ["text" :  urlItemString]
                     
                })

        }
        
    }
    
    func sharingPost( finished: @escaping () -> Void) {
       
             print("In Did Post")
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem  {
                     print("Item \(item)")
                    var flag = item.attachments!.count
                     for ele in item.attachments!{
                         print("item.attachments!======&gt;&gt;&gt; \(ele as! NSItemProvider)")
                         let itemProvider = ele as! NSItemProvider
                         print(itemProvider)
                        
                         processText(itemProvider: itemProvider)
                        
                         if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                            imageType = "public.jpeg"
                         } else if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
                            imageType = "public.png"
                         }
                        
                         if itemProvider.hasItemConformingToTypeIdentifier(imageType){
                             print("True")
                            itemProvider.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { [self] (item, error) in
                                 
                                 var imgData: Data!
                                 if let url = item as? URL{
                                     imgData = try! Data(contentsOf: url)
                                 }
                                 if let img = item as? UIImage{
                                    imgData = img.pngData()
                                 }
                                 
                                 print("Item ===\(item)")
                                 print("Image Data=====. \(imgData))")

                                let imgDict: [String : Any] = [ "imageData" : imgData, "imageText" : "imported image"]
                                imgDictArray.append(imgDict)
                                
                                let image = UIImage(data: imgData)!
                                importedImages.append(image)
                                flag -= 1
                                if flag == 0 {
                                    finished()
                                }
                                
                             })
                         }
                     }
                 }
             }
    
    func textNextButtonPressed() {
        importedElementsArray.append(textDict)
        print("URLData \(String(describing: savedata?.value(forKey: "imported")))")
        self.openURL(url: NSURL(string:"containerapp://HomeVC")!)
        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
    }
    
    func imageNextButtonPressed() {
        importedElementsArray.append(contentsOf: imgDictArray)
        print("ImageData \(String(describing: savedata?.value(forKey: "imported")))")
        self.openURL(url: NSURL(string:"containerapp://HomeVC")!)
        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
        
    }

    func openURL(url: NSURL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector(inBackground: "openURL:", with: url) != nil
        }
        catch {
            return false
        }
    }

    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.next
        }

        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
    
    
}
