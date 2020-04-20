//
//  EvaluateManagerViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/9.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class EvaluateManagerViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var evaluate: UIButton!
    @IBOutlet weak var finsh: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data: Evaluate? = nil
    var type: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setUp()
        loadEva()
    }

    func setUp() {
        title = "评价管理"
        evaluate.setTitleColor(evaluate.tintColor, for: .normal)
        finsh.setTitleColor(.black, for: .normal)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "OrderFInshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFInshTableViewCell")
        tableView.register(UINib(nibName: "OrderEvaluateFinshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderEvaluateFinshTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
    }

    func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
                   opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }
    @IBAction func eva(_ sender: Any) {
        type = "0"
        evaluate.setTitleColor(evaluate.tintColor, for: .normal)
        finsh.setTitleColor(.black, for: .normal)
        loadEva()
    }

    @IBAction func finsh(_ sender: Any) {
        type = "1"
        finsh.setTitleColor(evaluate.tintColor, for: .normal)
        evaluate.setTitleColor(.black, for: .normal)
        loadEva()
    }
    func loadEva() {
        API.evaluateManager(type: type, page: "1").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc func deleteEvaluate(btn: UIButton) {
        API.evaluateDelete(product_evaluate_id: data?.data[btn.tag - 1000].product_evaluate_id ?? "").request { (result) in
            switch result {
            case .success(_):
                self.loadEva()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
extension EvaluateManagerViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderEvaluateFinshTableViewCell") as! OrderEvaluateFinshTableViewCell
            let item = data?.data[indexPath.row]
            cell.dateLable.text = item?.created ?? "匿名用户"
            if !(item?.user_image?.isEmpty ?? true) {
            cell.userImg.af_setImage(withURL: URL(string: item?.user_image ?? "https://app.necesstore.com/upload/advert/o_10530652.jpg")!)
            } else {
                cell.userImg.af_setImage(withURL: URL(string: "https://app.necesstore.com/upload/advert/o_10530652.jpg")!)
            }
            cell.userName.text = item?.user_name
            cell.coment.text = item?.content ?? ""
            if (item?.evaluate_image?.count ?? 0) > 0 {
                cell.imgHeight.constant = 50
                for index in 0..<(item?.evaluate_image?.count ?? 0) {
                    let item = item?.evaluate_image?[index] ?? ""
                    if index == 0 {
                        cell.img1.af_setImage(withURL: URL(string: item)!)
                    } else if index == 1 {
                        cell.img2.af_setImage(withURL: URL(string: item)!)
                    } else if index == 2 {
                        cell.img3.af_setImage(withURL: URL(string: item)!)
                    } else if index == 3 {
                        cell.img4.af_setImage(withURL: URL(string: item)!)
                    } else if index == 4 {
                        cell.img5.af_setImage(withURL: URL(string: item)!)
                    }
                }
            } else {
                cell.imgHeight.constant = 0
            }
            cell.goodsImg.af_setImage(withURL: URL(string: item!.image)!)
            cell.goodsName.text = item?.name ?? ""
            cell.price.text = "￥\(item?.price ?? "0")"
            cell.star.text = "已好评"
            cell.deleteBtn.tag = indexPath.row + 1000
            cell.deleteBtn.addTarget(self, action: #selector(deleteEvaluate(btn:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFInshTableViewCell") as! OrderFInshTableViewCell
        let item = data?.data[indexPath.row]
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.name.text = item?.name ?? ""
        cell.price.text = "￥\(item?.price ?? "0")"
        cell.option.text = item?.optionUnionName ?? ""
        cell.num.text = "X\(item?.quantity ?? "0")"
        cell.selectionStyle = .none
        cell.shadow()
        cell.setBtn(flag: "1")
        cell.btn.tag = indexPath.row + 100
        cell.btn.addTarget(self, action: #selector(toAddEva(btn:)), for: .touchUpInside)
        return cell
    }

    @objc func toAddEva(btn: UIButton) {
        let addeva = AddEvaluateViewController()
        addeva.eva = data?.data[btn.tag - 100]
        self.navigationController?.pushViewController(addeva, animated: true)
    }

}
