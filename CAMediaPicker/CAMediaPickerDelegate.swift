//
//  CAMediaPickerDelegate.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import Foundation
import Photos

public protocol CAMediaPickerDelegate: NSObjectProtocol{
    @available(iOS 2.0, *)
    func mediaPickerControllerDidCancel()
    
    @available(iOS 2.0, *)
    func mediaPickerControllerDidSelectedImage(assets:[UIImage]);
    @available(iOS 8.0, *)
    func mediaPickerControllerDidFailWithAuthorizationStatus(status: PHAuthorizationStatus);
}

public protocol CASelectionDelegate: NSObjectProtocol{
      func controller(controller: UIViewController, didSelectedAssets assets:[PHAsset]);
}


