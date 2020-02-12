//
//  ViewController.swift
//  TestGonet
//
//  Created by Edwin Daniel on 2/11/20.
//  Copyright © 2020 Edwin Daniel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scOptions: UISegmentedControl!
    @IBOutlet weak var tvInfo: UITableView!
    @IBOutlet weak var lcConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClean: UIButton!
    @IBOutlet weak var btnInit: UIButton!
    
    var arrInfo: [InfoEntity] = []
    var arrThread:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMainViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tvInfo.reloadData()
    }
    
    func configureMainViewController(){
        // Change to light color.
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.navigationController?.navigationBar.barTintColor = .white
        // Table delegates
        self.tvInfo.delegate = self
        self.tvInfo.dataSource = self
        self.tvInfo.tableFooterView = UIView(frame: .zero)
        
        self.scOptions.selectedSegmentIndex = 0
        
        self.initTableInformation()
        
        //Configure Segmented Control
        self.scOptions.addTarget(self, action: #selector(onSegmentValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        //ADD actions to buttons.
        self.btnClean.addTarget(self, action: #selector(btnDidTapBtnClean(sender:)), for: .touchUpInside)
        self.btnInit.addTarget(self, action: #selector(btnDidTapBtnInit(sender:)), for: .touchUpInside)
        
    }
    
    @objc func btnDidTapBtnClean (sender: UIButton){
        self.arrThread.removeAll()
        self.tvInfo.reloadData()
    }
    
    @objc func btnDidTapBtnInit (sender: UIButton){
        self.initThreads()
        self.tvInfo.reloadData()
    }
    
    func showTable(){
        self.arrThread.removeAll()
        self.lcConstraint.constant = 10
        self.btnInit.isHidden = true
        self.btnClean.isHidden = true
        self.initTableInformation()
        self.tvInfo.reloadData()
    }
    
    func showThread(){
        self.arrInfo.removeAll()
        self.lcConstraint.constant = 50
        self.btnInit.isHidden = false
        self.btnClean.isHidden = false
        self.initThreads()
        self.tvInfo.reloadData()
    }
    
    func initThreads(){
        DispatchQueue.global(qos: .background).async {
            self.arrThread.append("Hilo A|Prioridad alta|Valor 3")
            DispatchQueue.main.async {
                self.tvInfo.reloadData()
            }
        }
        DispatchQueue.global(qos: .background).async {
            self.arrThread.append("Hilo B|Prioridad media|Valor 2")
            
            DispatchQueue.global(qos: .background).async {
                self.arrThread.append("Hilo C|Prioridad baja|Valor 1")
                DispatchQueue.main.async {
                    self.tvInfo.reloadData()
                }
            }
        }
    }
    
    func initTableInformation(){
        // Add info table.
        for n in 1...10 {
            let info = InfoEntity(title: "Prueba numero: \(n)", content: "Este es una prueba del componente \(n)")
            self.arrInfo.append(info)
        }
    }
    
    @objc func onSegmentValueChanged(sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            self.showTable()
        }else if sender.selectedSegmentIndex == 1{
            self.showThread()
        }
    }
    
    
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrInfo.count != 0 {
            return self.arrInfo.count
        }else if self.arrThread.count != 0{
            return self.arrThread.count
        }
        return self.arrInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.arrInfo.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier:StoryboardConstants.TableViewCell.CustomCell,
                                                     for: indexPath) as? CustomTableViewCell
            
            cell?.lblTitle.text = self.arrInfo[indexPath.row].title
            cell?.lblContent.text = self.arrInfo[indexPath.row].content
            return cell!
            
        }else if self.arrThread.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier:StoryboardConstants.TableViewCell.ThreadCell,
                                                     for: indexPath) as? ThreadTableViewCell
            
            cell?.lblText.text = self.arrThread[indexPath.row]
            return cell!
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboard.Main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.ViewController.DetailViewController) as? DetailViewController
        vc?.info = self.arrInfo[indexPath.row]
        vc!.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

