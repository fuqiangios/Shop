//
//  AddNewCommunityImgTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout

class AddNewCommunityImgTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    let height = (ScreenWidth - 50)/5
    var imgs: [String] = []
    var updateTableView: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp(text: "输入正文内容")
    }

    func updateImg() {
        if imgs.count > 6 { return }
        if imgs.count > 3 {
            collectionHeight.constant = height*2 + 8
        } else {
            collectionHeight.constant = height
        }
        updateTableView?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUp(text: String) {
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UINib.init(nibName: "AddEvluateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddEvluateCollectionViewCell")
    }

    func getImgs() -> [String] {
        return imgs
    }
    
}
extension AddNewCommunityImgTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgs.count == 6 {return 6}
        return imgs.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AddEvluateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEvluateCollectionViewCell", for: indexPath) as! AddEvluateCollectionViewCell
        if indexPath.item >= imgs.count {
            cell.imgView.isHidden = true
        } else {
            cell.imgView.isHidden = false
            cell.img.af_setImage(withURL: URL(string: imgs[indexPath.item])!)
            cell.closeBtn.tag = indexPath.item + 50
            cell.closeBtn.addTarget(self, action: #selector(deleteImg(btn:)), for: .touchUpInside)
        }
        return cell
    }

    @objc func deleteImg(btn: UIButton) {
        imgs.remove(at: btn.tag - 50)
        updateImg()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: height, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < imgs.count {
            return
        }
        selectPicture()
    }

    func selectPicture(){

        let alertController = UIAlertController(title: "图片选择", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (btn) in
            print("点击了取消")
        }
        let photoAlbumAction = UIAlertAction(title: "相册", style: UIAlertAction.Style.default) { (btn) in
            print("点击了相册")
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary

//            self.viewController()?.present(picker, animated: true, completion: nil)
            self.window?.rootViewController?.present(picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "相机", style: UIAlertAction.Style.default) { (btn) in
            print("点击了相机")
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera

            self.window?.rootViewController?.present(picker, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(photoAlbumAction)
        alertController.addAction(cameraAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)

    }
}
extension AddNewCommunityImgTableViewCell:UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        addPicture(image: image)
        uploadImg(imgs: image)
         picker.dismiss(animated: true, completion: nil)
    }

    func uploadImg(imgs: UIImage) {
        FNetWork.requestUpload(url: "myaccount/upload",data: [ imgs.jpegData(compressionQuality: 0.3)!], parm: "product_rvaluate_Image" , success: { (result) in
            print(result)
            let dic = result["data"] as! Dictionary<String, Any>
            let image = dic["image"]as!String
            self.imgs.append(urlheadr + image)
            self.updateImg()
            self.collectionView.reloadData()
            }) { (error) in
                print(error)
            }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.window?.rootViewController?.dismiss(animated: true, completion: {

        })
    }


}