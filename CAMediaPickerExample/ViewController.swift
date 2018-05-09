//
//  ViewController.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import UIKit
import Photos
import AVKit

class ViewController: UIViewController, CAMediaPickerDelegate {
    
    let kMediaType = "MediaType"
    let KMediaAsset = "MediaAsset"
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoAlbum: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoAlbum: UIButton!
    //----
    @IBOutlet weak var listCollectionView: UICollectionView!
    var collectionList: [[String: Any]] = []
    var thumbnailSize : CGSize!
    //MARK: -
    @IBAction func cameraButtonAction(sender: UIButton){
        self.openCAMediaPicker(withSourceType: CAMediaPickerSourceType.image)
    }
    
    @IBAction func photoAlbumButtonAction(sender: UIButton){
        self.openCAMediaPicker(withSourceType: CAMediaPickerSourceType.photoAlbum)
    }
    func openCAMediaPicker(withSourceType sourceType: CAMediaPickerSourceType) -> () {
        let pickerController = CAMediaManager.init(withController: self)
        pickerController.delegate = self
        pickerController.presentMediaPickerController(withSource: sourceType)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupUI()
    }
    func  setupUI() -> () {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.thumbnailSize = CGSize.init(width: 100, height: 130)
        }
        else{
            var width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            width -= 6
            self.thumbnailSize =  CGSize.init(width: width/4, height: width/4)
        }
        //register cell
        let nib = UINib.init(nibName: "CAImageCollectionViewCell", bundle: nil)
        self.listCollectionView.register(nib, forCellWithReuseIdentifier: KCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mediaPickerControllerDidCancel() {
        print("cancel selection")
    }
    func mediaPickerControllerDidSelectedImage(assets: [UIImage]) {
        for image in assets{
            var assetData: [String : Any] = [:]
            assetData[kMediaType] = "Image"
            assetData[KMediaAsset] = image
            self.collectionList.append(assetData)
        }
        self.listCollectionView.reloadData()
    }
    func mediaPickerControllerDidFailWithAuthorizationStatus(status: PHAuthorizationStatus) {
        print("fail")
    }
   
    func mediaPickerControllerDidSelectedVideo(videoAsset: [String : Any]) {
        var assetData: [String : Any] = [:]
        assetData[kMediaType] = "Video"
        assetData[KMediaAsset] = videoAsset["ThumbImage"]
        assetData["VideoUrl"] = videoAsset ["VideoUrl"]
        self.collectionList.append(assetData)
        self.listCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCellIdentifier, for: indexPath) as! CAImageCollectionViewCell
        let assetData = self.collectionList[indexPath.row]
        let mediaType = assetData[kMediaType] as! String
        if mediaType == "Image" {
            cell.thumbnailImageView.image = assetData[KMediaAsset] as? UIImage
            cell.iconImageView.image = UIImage.init(named: "image_icon")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.thumbnailSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
