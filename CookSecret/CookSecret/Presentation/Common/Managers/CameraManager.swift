//
//  AddRecipeSectionView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 26/11/23.
//

import UIKit
import AVFoundation
import Photos

public class CameraManager: NSObject {

    public weak var delegate: ImageManagerDelegate?
    private weak var viewController: UIViewController?

    public func openCamera(viewController: UIViewController,
                           cancelTitle: String) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.viewController = viewController

            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                requestCameraPermission()
            case .authorized:
                presentCamera()
            case .restricted, .denied:
                showAlertCameraPermission(cancelTitle: cancelTitle)
            default:
                break
            }
        }
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            guard accessGranted else { return }
            self.presentCamera()
        })
    }

    private func presentCamera() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera

            self.viewController?.present(imagePicker, animated: true, completion: nil)
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

extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let delegate = delegate {
            delegate.pictureTaken(image, completion: {
                picker.dismiss(animated: true, completion: nil)
            })
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }

}
