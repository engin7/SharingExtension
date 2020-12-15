import UIKit
 

 
class ShareViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!

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
    
    // ShareViewController continued from Step 1.

        override func viewDidLoad() {
            super.viewDidLoad()
          
            containerView.layer.cornerRadius = 15
            containerView.layer.masksToBounds = true
            // https://stackoverflow.com/questions/17041669/creating-a-blurring-overlay-view/25706250

            // only apply the blur if the user hasn't disabled transparency effects
            if UIAccessibility.isReduceTransparencyEnabled == false {
                view.backgroundColor = .clear

                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                view.insertSubview(blurEffectView, at: 0)
            } else {
                view.backgroundColor = .black
            }
            // Do any additional setup after loading the view.
            sharingPost()
        }
     
      func sharingPost() {
       
             print("In Did Post")
                 if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
                     print("Item \(item)")
                     for ele in item.attachments!{
                         print("item.attachments!======&gt;&gt;&gt; \(ele as! NSItemProvider)")
                         let itemProvider = ele as! NSItemProvider
                         print(itemProvider)

                        if itemProvider.hasItemConformingToTypeIdentifier(textType) {
                        
                                print("importing text")
                        
                            itemProvider.loadItem(forTypeIdentifier: textType, options: nil, completionHandler: { [self] (item, error) in
                                   
                                    print("Text item ===\(item)")
                                    
                                    let dict: [String : Any] = ["text" :  item]
                                    importedElementsArray.append(dict)
                                    
                                    print("TextData \(String(describing: savedata?.value(forKey: "imported")))")

                                })
                        } else if itemProvider.hasItemConformingToTypeIdentifier(urlType) {
                            
                            itemProvider.loadItem(forTypeIdentifier: urlType, options: nil, completionHandler: { [self] (item, error) in
                                   
                                let urlItem = item as! URL
                                let urlItemString = urlItem.absoluteString
                                
                                    print("URL item ===\(item)")
                                    
                                let dict: [String : Any] = ["text" :  urlItemString]
                                    importedElementsArray.append(dict)
                                    
                                    print("URLData \(String(describing: savedata?.value(forKey: "imported")))")

                                })
                            
                        } else {
                        
                         if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                            imageType = "public.jpeg"
                         }
                         if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
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
                                
                                
                                let image = UIImage(data: imgData)!
                                importedImages.append(image)
                                
                                 print("Item ===\(item)")
                                 print("Image Data=====. \(imgData))")
                                 let dict: [String : Any] = [ "imageData" : imgData, "imageText" : "images"]
                                 importedElementsArray.append(dict)
                                 print("ImageData \(String(describing: savedata?.value(forKey: "imported")))")
                             })
                         }
                         }
                     }
                    // reload
                    let image = #imageLiteral(resourceName: "sampleImage.jpeg")
                    importedImages.append(image)
                    imageSet = importedImages
                    ImgCollectionViewController()
               

                 }
             
             }
   

    func nextButton() {
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
