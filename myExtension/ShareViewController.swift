import UIKit
import MobileCoreServices

@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.handleSharedFile()
  }
  
    private func handleSharedFile() {
      // extracting the path to the URL that is being shared
        // We can access the attachments through the extensionContext
      let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
      let contentType = kUTTypeData as String // check content type
      for provider in attachments {
        // Check if the content type is the same as we expected
        if provider.hasItemConformingToTypeIdentifier(contentType) {
          provider.loadItem(forTypeIdentifier: contentType,
                            options: nil) { [unowned self] (data, error) in
          // Handle the error here if you want
          guard error == nil else { return }
               // cast image to an URL
          if let url = data as? URL,
             let imageData = try? Data(contentsOf: url) {
               self.save(imageData, key: "data", value: imageData)
          } else {
            // Handle this situation as you prefer
            fatalError("Impossible to save image")
          }
        }}
      }
    }
      // FIXME - not a good approach to save large files to userDefaults, this is only for demonstration
    private func save(_ data: Data, key: String, value: Any) {
      let userDefaults = UserDefaults()
      userDefaults.set(data, forKey: key)
    }
    
}
