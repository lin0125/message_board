//
//  MainViewController.swift
//  realmtest
//
//  Created by imac-2437 on 2023/7/12.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tabelview: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageInput: UITextView!
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var sortby: UIButton!
    
    var iteamTabel: [IteamTable] = []
    var sortbyy1: [IteamTable] = []
    
    var steptime: Int = 0
    var timeStamp: Int?
    
    var rightbool = false
    var sortbybool = true
    var stepuuid: ObjectId?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enter.layer.cornerRadius = 10
        sortby.layer.cornerRadius = 10
        userName.layer.cornerRadius = 2
        
        tabelview.layer.cornerRadius = 15
        tabelview.layer.borderWidth = 0.5
        
        messageInput.layer.cornerRadius = 15
        messageInput.layer.borderWidth = 0.5
        
        userInput.borderStyle = .roundedRect
        
        fetchData()
        
        tabelview?.register(UINib(nibName: "MainTableViewCell", bundle: nil),
                            forCellReuseIdentifier: MainTableViewCell.identifier)
        tabelview?.delegate = self
        tabelview?.dataSource = self
    }
    
    func fetchData() {
        iteamTabel = []
        let realm = try! Realm()
        let dogs = realm.objects(iteamTable.self)
        if ( sortbybool == true) {
            if dogs.count > 0 {
                for i in 0...dogs.count - 1 {
                    let item = IteamTable(name: dogs[i].name,
                                          content: dogs[i].content,
                                          timeStamp: dogs[i].timeStamp,
                                          uuid: dogs[i].uuid)
                    iteamTabel.append(item)
                }
            }
            print("file\(realm.configuration.fileURL!)")
        } else {
            if dogs.count > 0 {
                for i in 0...dogs.count - 1 {
                    let item = IteamTable(name: dogs[i].name,
                                          content: dogs[i].content,
                                          timeStamp: dogs[i].timeStamp,
                                          uuid: dogs[i].uuid)
                    iteamTabel.append(item)
                    self.iteamTabel.sort(by: {m1, m2 in
                        m1.timeStamp > m2.timeStamp
                    })
                }
            }
            print("file\(realm.configuration.fileURL!)")
        }
    }
    //            array寫法
    //            for iteamTabel in iteamTabel {
    //                sortbyy1.append(iteamTabel)
    //            }
    
    //            realm寫法
    //            self.timmer1 = dogs.sorted(byKeyPath: "timeStamp", ascending: true)
    //            self.timmer2 = dogs.sorted(byKeyPath: "timeStamp", ascending: false)
    
    @IBAction func enter(_ sender: Any) {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        timeStamp = Int(timeInterval)
        if (rightbool == false) {                           //正常編輯
            let userstring = userInput.text!
            let messagestring = messageInput.text!
            
            let realm = try! Realm()                      //將資料寫入Realm
            let pp = iteamTable(name: userstring,
                                content: messagestring,
                                timeStamp: timeStamp!)
            try! realm.write {
                realm.add(pp)
            }
            
            let nnail: String = ""           //輸入完清空欄位
            userInput.text = nnail
            messageInput.text = nnail
            
            fetchData()
            tabelview.reloadData()
        } else {
            //右滑編輯時
            let realm = try! Realm()
            let todoToDelete = self.stepuuid
            let todosInProgress = realm.objects(iteamTable.self).where {   //在Realm中尋找該項的值
                $0.uuid == todoToDelete!
            }
            let todoToUpdate = todosInProgress                           //將資料重新寫入Ｒealm中該項當中
            try! realm.write {
                todoToUpdate[0].name = userInput.text!
                todoToUpdate[0].content = messageInput.text!
                
            }
            let nnail: String = ""           //輸入完清空欄位
            userInput.text = nnail
            messageInput.text = nnail
            
            //            fetchData()
            tabelview.reloadData()
            return rightbool = false
        }
    }
    
    
    @IBAction func sortby(_ sender: Any) {
        
        let controller =  UIAlertController (title: "排序" , message: "新舊" , preferredStyle: .actionSheet)
        let names = [ "新->舊" , "舊->新" ]
        
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { [self] action in
                if action.title == names[0] {
                    
                    self.iteamTabel.sort(by: { m1, m2 in
                        m1.timeStamp < m2.timeStamp
                    })
                    self.tabelview.reloadData()
                    return sortbybool = true
                } else {
                    self.iteamTabel.sort(by: { m1, m2 in
                        m1.timeStamp > m2.timeStamp
                    })
                    self.tabelview.reloadData()
                    return sortbybool = false
                }
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iteamTabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.label1?.text = iteamTabel[indexPath.row].name
        cell.label2?.text = iteamTabel[indexPath.row].content
        return cell
    }
    
    //左滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, complete) in
            let realm = try! Realm()
            let dogs = realm.objects(iteamTable.self)
            
            
            let todoToDelete = dogs[indexPath.row].uuid
            try! realm.write {
                let todosInProgress = dogs.where {
                    $0.uuid == todoToDelete
                }
                realm.delete(todosInProgress)
            }
            self.iteamTabel.remove(at: indexPath.row)
            self.tabelview.deleteRows(at: [indexPath], with: .top)
            //            tableView.reloadData()
            complete(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let trailingSwipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return trailingSwipConfiguration
        
    }
    
    //右滑編輯
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let wantAction = UIContextualAction(style: .normal, title: "編輯") { [self] (action, view, completionHandler) in
            let realm = try! Realm()
            let dogs = realm.objects(iteamTable.self)
            
            self.stepuuid = iteamTabel[indexPath.row].uuid
            let todosInProgress = dogs.where {
                $0.uuid == stepuuid!
            }
            
            self.userInput.text = todosInProgress[0].name
            self.messageInput.text = todosInProgress[0].content
            
            //                self.steptime = todosInProgress[0].timeStamp
            //                self.stepuuid = todosInProgress[0].uuid
            
            //                self.userinput.text = self.iteamTabel[indexPath.row].name
            //                self.messageinput.text = self.iteamTabel[indexPath.row].content
            
            completionHandler(true)
            return self.rightbool = true
        }
        return UISwipeActionsConfiguration(actions: [wantAction])
    }
}           

