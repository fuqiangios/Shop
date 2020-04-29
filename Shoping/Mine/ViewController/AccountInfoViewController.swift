//
//  AccountInfoViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var name = ""
    var sex = "1"
    var dat = ""
    var phone = ""
    var email = ""
    var img = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号设置"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.register(UINib(nibName: "AccountInfoImageTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountInfoImageTableViewCell")
        tableView.register(UINib(nibName: "AccountInputTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountInputTableViewCell")
        tableView.register(UINib(nibName: "AccountSexTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountSexTableViewCell")
        tableView.register(UINib(nibName: "AccountSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountSubmitTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.rowHeight = UITableView.automaticDimension
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    func loadData() {
        API.getUserInfo().request { (result) in
            switch result {
            case .success(let data):
                self.name = data.data.name
                self.sex = data.data.sex
                self.dat = data.data.birthday
                self.phone = data.data.telephone
                self.email = data.data.email
                self.img = data.data.image
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension AccountInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 || section == 2 {
            return 1
        }
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    @objc func qiAction() {
        sex = "1"
        tableView.reloadData()
    }

    @objc func geAction() {
        sex = "2"
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSubmitTableViewCell") as! AccountSubmitTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInfoImageTableViewCell") as! AccountInfoImageTableViewCell
            if !img.isEmpty {
            cell.img.af_setImage(withURL: URL(string: img)!)
            }
        cell.selectionStyle = .none
        return cell
        } else {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSexTableViewCell") as! AccountSexTableViewCell
                cell.selectionStyle = .none
                if sex == "1" {
                    cell.nv.setImage(UIImage(named: "选中"), for: .normal)
                    cell.nan.setImage(UIImage(named: "未选择"), for: .normal)
                } else {
                    cell.nan.setImage(UIImage(named: "选中"), for: .normal)
                    cell.nv.setImage(UIImage(named: "未选择"), for: .normal)
                }
                cell.nv.addTarget(self, action: #selector(qiAction), for: .touchUpInside)
                cell.nan.addTarget(self, action: #selector(geAction), for: .touchUpInside)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInputTableViewCell") as! AccountInputTableViewCell
            cell.selectionStyle = .none
            if indexPath.row == 0  {
                cell.name.text = "昵称"
                cell.input.placeholder = "请输入昵称"
                cell.btn.isHidden = true
                cell.input.text = name
                cell.input.delegate = self
                cell.input.tag = 21
                cell.input.isEnabled = true
            } else if indexPath.row == 2 {
                cell.name.text = "出生日期"
                cell.input.placeholder = "请选择出生日期"
                cell.btn.isHidden = true
                cell.input.text = dat
                cell.input.delegate = self
                cell.input.tag = 20
                cell.input.isEnabled = true
            } else if indexPath.row == 3 {
                cell.name.text = "电话"
                cell.input.placeholder = ""
                cell.btn.isHidden = false
                cell.input.text = phone
                cell.input.isEnabled = false
                cell.btn.addTarget(self, action: #selector(updateAc), for: .touchUpInside)
            } else if indexPath.row == 4 {
                cell.name.text = "邮箱"
                cell.input.placeholder = ""
                cell.btn.isHidden = false
                cell.input.text = email
                cell.input.isEnabled = false
                cell.btn.addTarget(self, action: #selector(updateEmail), for: .touchUpInside)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 188
        } else if indexPath.section == 2 {
            return 95
        }
        else {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        vi.backgroundColor = UIColor.tableviewBackgroundColor
        return vi
    }

    func submit() {
        API.updateUserInfo(name: name, image: img, sex: sex, birthday: dat).request { (result) in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(let er):
                print(er)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            selectPicture()
        }
        if indexPath.section == 2 {
             submit()
         }
    }

    func selectDate() {
        let datepicker = WSDatePickerView(dateStyle: DateStyleShowYearMonth) { (dat) in
            self.dat = self.dateConvertString(date: dat ?? Date.init())
            self.tableView.reloadData()
        }
        datepicker?.show()
    }

    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let date = formatter.string(from: date)
            return date
        }

    @objc func updateAc() {
        let ac = AccountUpdateViewController()
        ac.oldPhone = phone
        self.navigationController?.pushViewController(ac, animated: true)
    }

    @objc func updateEmail() {
        let ac = EmailUpdateViewController()
        self.navigationController?.pushViewController(ac, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

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
                self.present(picker, animated: true, completion: nil)
            }
            let cameraAction = UIAlertAction(title: "相机", style: UIAlertAction.Style.default) { (btn) in
                print("点击了相机")
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera

                self.present(picker, animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(photoAlbumAction)
            alertController.addAction(cameraAction)
            self.present(alertController, animated: true, completion: nil)

        }
}
extension AccountInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 21 {
        name = textField.text ?? ""
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 20 {
            selectDate()
            return false
        }
        return true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        uploadImg(imgs: image)
         picker.dismiss(animated: true, completion: nil)
    }

    func uploadImg(imgs: UIImage) {
        FNetWork.requestUpload(url: "myaccount/upload",data: [ imgs.jpegData(compressionQuality: 0.3)!], parm: "customer" , success: { (result) in
            print(result)
            let dic = result["data"] as! Dictionary<String, Any>
            let image = dic["image"]as!String
            self.img = urlheadr + image
            self.tableView.reloadData()
            }) { (error) in
                print(error)
            }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {

        })
    }
}
