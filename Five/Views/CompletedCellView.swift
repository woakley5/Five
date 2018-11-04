//
//  CompletedCellView.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Niky Arora. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CompletedCellView: SpringView {
    
    var background: UIVisualEffectView!
    var header: UIView!
    var headerLabel: UILabel!
    var headerColor: UIColor!
    var taskTableView: UITableView!
    var numCompletedLabel: UILabel!
    
    var taskTag: TaskTag!
    var list: [Task]!
    
    var personalTasks: [Task] = []
    var workTasks: [Task] = []
    var financeTasks: [Task] = []
    var homeTasks: [Task] = []
    
    
    var expanded = false
    
    init(frame: CGRect, color: UIColor, tag: TaskTag) {
        super.init(frame: frame)
        self.headerColor = color
        self.taskTag = tag
        animation = "slideUp"
        initUI()
        initLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayer() {
        background.layer.cornerRadius = 20
        background.clipsToBounds = true
        header.clipsToBounds = true
        header.layer.cornerRadius = 20
        // self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 6)
        self.layer.shadowOpacity = 0.5
        
    }
    
    private func initUI() {
        background = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
        background.effect = UIBlurEffect(style: .light)
        addSubview(background)
        
        header = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        header.backgroundColor = headerColor
        addSubview(header)
        
        headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 30, height: self.frame.height - 20))
        headerLabel.text = "Work"
        headerLabel.textColor = .white
        headerLabel.font = UIFont(name: "Quicksand-Bold", size: 24)
        header.addSubview(headerLabel)
        
        numCompletedLabel = UILabel(frame: CGRect(x: self.frame.width - 10 - 90, y: 10, width: 90, height: self.frame.height - 20))
        numCompletedLabel.textColor = .white
        numCompletedLabel.textAlignment = .right
        numCompletedLabel.font = UIFont(name: "Quicksand-Bold", size: 24)
        header.addSubview(numCompletedLabel)
        
        taskTableView = UITableView(frame: CGRect(x: 0, y: header.frame.maxY, width: self.frame.width, height: self.header.frame.height * 4 - 60), style: UITableView.Style.plain)
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = .clear
        background.contentView.addSubview(taskTableView)
        
        workTasks = TaskList.getCompletedTasksByTag(tag: .work)
        homeTasks = TaskList.getCompletedTasksByTag(tag: .home)
        financeTasks = TaskList.getCompletedTasksByTag(tag: .finance)
        personalTasks = TaskList.getCompletedTasksByTag(tag: .personal)
        
        if taskTag == .work {
            list = workTasks
        } else if taskTag == .finance {
            list = financeTasks
        } else if taskTag == .home {
            list = homeTasks
        } else {
            list = personalTasks
        }
        
        numCompletedLabel.text = "\(list.count) done"

        taskTableView.reloadData()
    }
    
    func expand() {
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.header.frame.height * 4.3)
            self.background.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.header.frame.height * 4.3)
        }
    }
    
    func contract() {
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.header.frame.height)
            self.background.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
    }
    
    func animate(toFrame: CGRect, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = toFrame
            self.background.frame = CGRect(x: 0, y: 0, width: toFrame.width, height: self.background.frame.height)
            //self.header.frame = CGRect(x: 0, y: 0, width: toFrame.width, height: toFrame.height)
        }) { (done) in
            completion()
        }
    }
}

extension CompletedCellView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuse")
        cell.awakeFromNib()
        cell.textLabel?.text = list[indexPath.row].text
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Quicksand-Regular", size: 16)
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    
}
