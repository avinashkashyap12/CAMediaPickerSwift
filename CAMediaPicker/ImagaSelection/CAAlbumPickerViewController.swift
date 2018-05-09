//
//  CAAlbumPickerViewController.swift
//  CAMediaPickerExample
//
//  Created by Avinash Kashyap on 29/04/18.
//  Copyright © 2018 Avinash Kashyap. All rights reserved.
//

import UIKit
import Photos

class CAAlbumPickerViewController: UIViewController, CASelectionDelegate {
    
    @IBOutlet weak var albumListTableView: UITableView!
    var albumList: [[String: Any]] = []
    weak var delegate: CASelectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Albums"
        //add cancel button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction(sender:)))
        //register cell
        let nib = UINib.init(nibName: "CAAlbumTableViewCell", bundle: nil)
        self.albumListTableView.register(nib, forCellReuseIdentifier: KCellIdentifier)
        self.albumListTableView.tableFooterView = UIView.init()
        self.fetchAllAlbumAssetCollection()
    }
    @objc func cancelButtonAction(sender: Any) -> () {
        self.dismiss(animated: true, completion: nil)
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
    //MARK:- Fetch all album assets collection
    func fetchAllAlbumAssetCollection() -> () {
        var tempArray: [[String: Any]] = []
        //fetch all smart albums
        let smartAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil);
        //---
        for i in  0..<smartAlbums.count{
            let collection = smartAlbums[i]
            var data: [String: Any] = ["AssetCollection":collection]
            if let thumbAssets = self.getThumbnailAssetForAssetCollection(collection: collection){
                data["ThumbnailAsset"] = thumbAssets
            }
            tempArray.append(data)
        }
        //fetch all user album list
        let userAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        for i in  0..<userAlbums.count{
            let collection = userAlbums[i]
            var data: [String: Any] = ["AssetCollection":collection]
            if let thumbAssets = self.getThumbnailAssetForAssetCollection(collection: collection){
                data["ThumbnailAsset"] = thumbAssets
            }
            tempArray.append(data)
        }
        //------
        self.albumList = tempArray
        self.albumListTableView.reloadData()
    }//--
    func getThumbnailAssetForAssetCollection(collection: PHAssetCollection) -> PHAsset? {
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        return assets.lastObject
    }
}
extension CAAlbumPickerViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KCellIdentifier) as? CAAlbumTableViewCell
        let cellData = self.albumList[indexPath.row]
        let collection: PHAssetCollection = cellData["AssetCollection"] as! PHAssetCollection
        cell?.titleLabel.text = collection.localizedTitle
        //set thumbnail
        if let asset = cellData["ThumbnailAsset"]{
            cell?.albumImageView.setImageFromAsset(asset: asset as! PHAsset)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.displayCollectionImageController(forIndexPath: indexPath)
    }
    //-----display album's image
    func displayCollectionImageController(forIndexPath indexPath: IndexPath) -> () {
        let controller = CAImagePickerViewController.init(nibName: "CAImagePickerViewController", bundle: nil)
        let cellData = self.albumList[indexPath.row]
        controller.imageSelectionDelegate = self
        let collection: PHAssetCollection = cellData["AssetCollection"] as! PHAssetCollection
        controller.setSelectedAssetCollection(collection: collection)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func controller(controller: UIViewController, didSelectedAssets assets: [PHAsset]) {
        self.delegate?.controller(controller: self.navigationController!, didSelectedAssets: assets)
    }
    func controller(controller: UIViewController, didSelectedVideoAsset asset: [String : Any]) {
        
    }
}
