//
//  CAImagePickerViewController.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import UIKit
import Photos

class CAImagePickerViewController: UIViewController {

    @IBOutlet var imageCollectionView: UICollectionView!
    var imageAssetList: [Any] = []
    var selectedAssetCollection: PHAssetCollection!
    var thumbnailSize : CGSize!
    var selectedCellList: [IndexPath] = []
    var doneBarButton: UIBarButtonItem!
    weak var imageSelectionDelegate: CASelectionDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        //--
        self.getAllAssets()
    }
    func setupUI() -> () {
        //set title
        self.title = "Images"
        //set thumbnail size
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.thumbnailSize = CGSize.init(width: 100, height: 130)
        }
        else{
            var width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            width -= 6
            self.thumbnailSize =  CGSize.init(width: width/4, height: width/4)
        }
        if(isMultiSelectionAllow==true){
            //add navigation bar button
            self.doneBarButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneBarButtonItemAction(sender:)))
            self.doneBarButton.isEnabled = false
            self.navigationItem.rightBarButtonItem = self.doneBarButton
        }
        
        //register cell
        let nib = UINib.init(nibName: "CAImageCollectionViewCell", bundle: nil)
        self.imageCollectionView.register(nib, forCellWithReuseIdentifier: KCellIdentifier)
    }
    func setSelectedAssetCollection(collection: PHAssetCollection) -> () {
        self.selectedAssetCollection = collection
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Get All Assets
    func getAllAssets() -> () {
        if self.selectedAssetCollection == nil {
            return
        }
        let options = PHFetchOptions.init()
        options.includeAssetSourceTypes = .typeUserLibrary
        let assetsResult = PHAsset.fetchAssets(in: self.selectedAssetCollection, options: options)
        var i = assetsResult.count-1
        repeat{
            let asset = assetsResult[i]
            self.imageAssetList.append(asset)
            i -= 1
        }while i>=0
        self.imageCollectionView.reloadData()
    }
}
extension CAImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageAssetList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCellIdentifier, for: indexPath) as! CAImageCollectionViewCell
        let asset = self.imageAssetList[indexPath.row] as! PHAsset
        cell.thumbnailImageView.setImageWithAsset(asset: asset, inSize: self.thumbnailSize)
        if self.selectedCellList.contains(indexPath) {
            cell.iconImageView.image = UIImage.init(named: "check_red")
        }
        else{
            cell.iconImageView.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.thumbnailSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //check multiple selection allow or not
        if isMultiSelectionAllow == false{
            self.selectedCellList.append(indexPath)
            self.sendSelectionDelegateMessage()
            return
        }
        //-------
        let cell = collectionView.cellForItem(at: indexPath) as! CAImageCollectionViewCell
        if self.selectedCellList.contains(indexPath) {
            self.selectedCellList.remove(at: self.selectedCellList.index(of: indexPath)!)
            cell.iconImageView.image = nil
        }
        else{
            if self.selectedCellList.count == KMaximumSelection {
                return;
            }
            self.selectedCellList.append(indexPath)
            cell.iconImageView.image = UIImage.init(named: "check_red")
        }
        self.doneBarButton.isEnabled = self.selectedCellList.count > 0 ? true : false
        
    }
    @objc func doneBarButtonItemAction(sender: UIBarButtonItem) -> () {
        self.sendSelectionDelegateMessage()
    }
    func sendSelectionDelegateMessage() -> () {
        var tempArray : [PHAsset] = []
        for indexPath in self.selectedCellList{
            let asset = self.imageAssetList[indexPath.row] as! PHAsset
            tempArray.append(asset)
        }
        
        self.imageSelectionDelegate?.controller(controller: self, didSelectedAssets: tempArray)
    }
    
}
