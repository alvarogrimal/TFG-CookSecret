//
//  AddRecipeSectionView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 26/11/23.
//

import UIKit
import Photos

@objc public protocol ImageManagerDelegate: AnyObject {
    @objc func pictureTaken(_ image: UIImage, completion: @escaping () -> Void)
}

public class GalleryManager: NSObject {

    public weak var delegate: ImageManagerDelegate?
    private weak var viewController: UIViewController?
    let imagePicker = UIImagePickerController()
    
    public override init() {
        super.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    public func openGallery(viewController: UIViewController,
                            cancelTitle: String) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.viewController = viewController

            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                requestGalleryPermission()
            case .authorized:
                presentGallery()
            case .restricted, .denied:
                showAlertCameraPermission(cancelTitle: cancelTitle)
            default:
                break
            }
        }
    }

    private func requestGalleryPermission() {
        PHPhotoLibrary.requestAuthorization { accessGranted in
            guard accessGranted == PHAuthorizationStatus.authorized else { return }
            self.presentGallery()
        }
    }

    private func presentGallery() {
        DispatchQueue.main.async {
            self.viewController?.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    private func showAlertCameraPermission(cancelTitle: String) {
        let actions = [UIAlertController.getCancelAction(title: cancelTitle),
                       UIAlertController.getSettingsAction()]

        let alertController = UIAlertController(title: "",
                                                message: "",
                                                preferredStyle: .alert)

        for action in actions {
            alertController.addAction(action)
        }

        viewController?.present(alertController, animated: true, completion: nil)
    }

}

extension GalleryManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let delegate = delegate{
            delegate.pictureTaken(image, completion: {
                picker.dismiss(animated: true, completion: nil)
            })
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }

}
