//
//  CAMediaManager.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

public enum CAMediaPickerSourceType: Int{
    case image
    
    case photoAlbum
    
}

class CAMediaManager: NSObject, PHPhotoLibraryChangeObserver, CASelectionDelegate {
    var pickerSourceType: CAMediaPickerSourceType!
    var ownerController: UIViewController!
    var mediaPickerManager: CAMediaManager!
    var authorizationStatus: PHAuthorizationStatus!
    weak var delegate: CAMediaPickerDelegate?
    
    convenience init(withController controller: UIViewController){
        self.init()
        self.ownerController = controller
        self.mediaPickerManager = self
        isMultiSelectionAllow = true
    }
    //MARK: -
    func presentMediaPickerController() -> () {
        self.presentMediaPickerController(withSource: .image)
    }
    func presentMediaPickerController(withSource sourceType: CAMediaPickerSourceType) -> () {
        self.pickerSourceType = sourceType
        if sourceType == .image {
            self.checkAuthorizationStatusForCameraUse()
            return;
        }
        self.CheckAlbumAccessAuthorizationAndDisplay(sourceType: sourceType)
    }
    func openPickerControllerWithSource(sourceType: CAMediaPickerSourceType) -> () {
        if sourceType == .image {
            self.displayImagePickerController(withSourceType: sourceType)
        }
        else if sourceType == .photoAlbum{
            self.displayAlbumPickerController()
        }
    }
    //MARK:- check authorization for camera
    func checkAuthorizationStatusForCameraUse(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .authorized {
            self.openPickerControllerWithSource(sourceType: self.pickerSourceType);
            return;
        }
        else if authStatus == .denied{
            print("display alert message")
        }
        else if authStatus == .restricted{
            print("display alert message")
        }
        else if authStatus == .notDetermined{
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted == true{
                    self.openPickerControllerWithSource(sourceType: self.pickerSourceType)
                }
                else{
                    print("not granted to access media, display message, It seems application is not able to use camera due to permisssion denied.")
                }
            })
        }
        else{
            print("Unknown status found")
        }
        
    }
    //MARK:- Chekc authorization for Album access
    func CheckAlbumAccessAuthorizationAndDisplay(sourceType: CAMediaPickerSourceType) -> () {
        self.authorizationStatus = self.getAuthorizationStatus()
        if self.authorizationStatus == PHAuthorizationStatus.notDetermined {
            //PHPhotoLibrary.shared().register(self)
            self.requestForAuthorization()
            return
        }
        else if self.authorizationStatus == PHAuthorizationStatus.restricted || self.authorizationStatus == PHAuthorizationStatus.denied{
            return
        }
        self.openPickerControllerWithSource(sourceType: sourceType)
    }
    func getAuthorizationStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    func requestForAuthorization() -> () {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.authorized{
                print("display album list")
                DispatchQueue.main.async {
                    self.openPickerControllerWithSource(sourceType: self.pickerSourceType)
                }
            }
            else{
                print("not granted to access media, display message, It seems application is not able to use camera due to permisssion denied.")
            }
        }
    }
    public func photoLibraryDidChange(_ changeInstance: PHChange){
        let newStatus = self.getAuthorizationStatus()
        if newStatus == PHAuthorizationStatus.authorized && self.authorizationStatus != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.shared().unregisterChangeObserver(self)
            self.openPickerControllerWithSource(sourceType: self.pickerSourceType)
        }
    }
    
}
//MARK: - Open picker
extension CAMediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func displayImagePickerController(withSourceType type:CAMediaPickerSourceType) -> () {
        let imagePickerController = UIImagePickerController.init()
        imagePickerController.sourceType = .camera
        imagePickerController.view.tag = 1
        imagePickerController.delegate = self.mediaPickerManager
        self.ownerController.present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: - Image Picker controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel picker")
        //dismiss picker controller
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //dismiss picker controller
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.delegate?.mediaPickerControllerDidSelectedImage(assets: [image as! UIImage])
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK: - Display image Album picker controller
    func displayAlbumPickerController() -> () {
        let controller = CAAlbumPickerViewController.init(nibName: "CAAlbumPickerViewController", bundle: nil)
        controller.delegate = self
        let navController = UINavigationController.init(rootViewController: controller)
        self.ownerController.present(navController, animated: true, completion: nil)
    }
    func controller(controller: UIViewController, didSelectedAssets assets: [PHAsset]) {
        //get images from all selected assets
        let manager = PHImageManager.default()
        var tempArray: [UIImage] = []
        var count: Int = 0
        for asset in assets{
             manager.requestImage(for: asset, targetSize: CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: PHImageContentMode.default, options: nil) { (result, info) in
                if let image = result{
                    tempArray.append(image)
                }
                
                count += 1
                if count == assets.count{
                    self.delegate?.mediaPickerControllerDidSelectedImage(assets: tempArray)
                }
            }
        }//end for loop
        //dismiss controller
        controller.dismiss(animated: true, completion: nil)
    }
    
}
