//
//  ImagePickerController.swift
//  Framework
//
//  Created by Narendra Bdr Kathayat on 2/18/20.
//  Copyright © 2020 EBpearls. All rights reserved.
//

import UIKit
import Combine

/// The image data structure
public struct Image {
    
    /// The edited image if available
    public var editedImage: UIImage?
    
    /// The original picked image
    public var originalImage: UIImage?
    
    /// The URL of the picked image
    public var url: URL?
}

//// The image picker class
final public class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// The source type user has selected
    private let sources: [UIImagePickerController.SourceType]
    
    /// The picked image info
    public var pickedImage = PassthroughSubject<Image, Never>()
    
    /// Should there be editing of image or not
    private let editingEnabled: Bool
    
    /// The presenter to present the action sheet and the image pikcer
    private weak var presenter: UIViewController?
    
    /// Initializer
    public init(presenter: UIViewController?, sources: [UIImagePickerController.SourceType], editingEnabled: Bool = false) {
        self.presenter = presenter
        self.sources = sources
        self.editingEnabled = editingEnabled
        super.init()
    }
    
    /// The imagePicker controller instance
    private lazy var imagePickerController: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    /// Method to provide the options to pick image from available source
    public func start() {
        
        /// check if we have the presenter controller
        guard let presenter = presenter else {
            assertionFailure("The presenter controller should be provided")
            return
        }
        
        //// build the options
        let alert = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        for source in sources {
            if UIImagePickerController.isSourceTypeAvailable(source) {
                switch source {
                case .savedPhotosAlbum:
                    let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .default) {[weak self, weak presenter] _ in
                        guard let self = self, let presenter = presenter else { return }
                        self.pick(forSource: .savedPhotosAlbum, presenter: presenter)
                    }
                    alert.addAction(photoAlbumAction)
                case .camera:
                    let cameraAction = UIAlertAction(title: "Camera", style: .default) {[weak self, weak presenter] _ in
                        guard let self = self, let presenter = presenter else { return }
                        self.pick(forSource: .camera, presenter: presenter)
                    }
                    alert.addAction(cameraAction)
                case .photoLibrary:
                    let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) {[weak self, weak presenter] _ in
                        guard let self = self, let presenter = presenter else { return }
                        self.pick(forSource: .photoLibrary, presenter: presenter)
                    }
                    alert.addAction(photoLibrary)
                default: break
                }
            }
        }
        
        // add the cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        // present the sheet
        presenter.present(alert, animated: true, completion: nil)
    }
    
    /// Method that will display the image picker controller for image picking
    /// - Parameters:
    ///   - source: the source of the images
    ///   - presenter: the presenter to present
    private func pick(forSource source: UIImagePickerController.SourceType, presenter: UIViewController) {
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        imagePickerController.allowsEditing = editingEnabled
        presenter.present(imagePickerController, animated: true, completion: nil)
    }
    
    /// simply dimiss when canceled
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// delegate to get the picked image
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the info
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let url = info[UIImagePickerController.InfoKey.imageURL] as? URL
        
        // create and send the Image structure
        let image = Image(editedImage: editedImage, originalImage: originalImage, url: url)
        pickedImage.send(image)
        
        // dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// deint call
    deinit {
        debugPrint("De-Initialized \(String(describing: self))")
    }
}
