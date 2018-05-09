//
//  CAConstant.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import Foundation
import UIKit
import Photos

let KCellIdentifier = "CellIdentifier"
let KMaximumSelection:Int = 5
var isMultiSelectionAllow: Bool = true

func createThumbnailImage(url: URL) -> UIImage? {
    let asset = AVAsset.init(url: url)
    let imageGenerator = AVAssetImageGenerator.init(asset: asset)
    let time = CMTime.init(value: 1, timescale: 1)
    do{
        let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        let image = UIImage.init(cgImage: imageRef)
        return image
    }catch let error {
        print(error)
    }
    return nil
}
extension UIImageView{
    func setImageFromAsset(asset: PHAsset) -> () {
        self.setImageWithAsset(asset: asset, inSize: CGSize.init(width: 90, height: 90))
    }
    func setImageWithAsset(asset: PHAsset, inSize size: CGSize) ->  (){
        let imageManger = PHImageManager.default()
        imageManger.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil) { (result, info) in
            self.image = result
        }
    }
}
