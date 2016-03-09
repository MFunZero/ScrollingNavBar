//
//  FourthTableViewController.swift
//  Originality
//
//  Created by suze on 16/2/9.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class FourthTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let rightButton = UIBarButtonItem(title: "登陆", style: .Done, target: self, action: "loginButtonClick:")
        //
        //        self.navigationItem.rightBarButtonItem = rightButton
        //        self.navigationItem.rightBarButtonItem?.tintColor = titleCorlor
        
        self.view.backgroundColor = bgColor
        
        
        
        self.tableView.registerClass(UserTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: "reuse")
        
        self.tableView.contentSize = CGSize(width: screenWidth, height: self.tableView.frame.height + 100)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 2
        }
        else if section == 2{
            return 1
        }
        else if section == 3 {
            return 3
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UserTableViewCell
            cell.avatarView.image = UIImage(named: "default_avatar")
            cell.nameLabel.text = "小财神"
            return cell
        }
      else {
            let cell = tableView.dequeueReusableCellWithIdentifier("reuse", forIndexPath: indexPath) as! PersonTableViewCell
            let tag = indexPath.row
            switch tag {
            case 0:
                cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                cell.titleLabel.text = "小财神"
            case 1:
                cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                cell.titleLabel.text = "小财神"
            default:
                cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                cell.titleLabel.text = "小财神"
        }
            
           if indexPath.section == 2 {
            
                cell.picture.image = UIImage(named: "default_avatar")
                cell.titleLabel.text = "小财神"
            }
           if indexPath.section == 3{
            
                let tag = indexPath.row
                switch tag {
                case 0:
                    cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                    cell.titleLabel.text = "小财神"
                case 1:
                    cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                    cell.titleLabel.text = "小财神"
                default:
                    cell.picture.image = UIImage(named: "tabbar_compose_book@2x")
                    cell.titleLabel.text = "小财神"
            }
                }
             if indexPath.section == 4 {
                
                    cell.picture.image = UIImage(named: "default_avatar")
                    cell.titleLabel.text = "小财神"
                     cell
                }
            
            return cell
    }
    
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0.01
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100
            
        }
        else {
            return 40
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        else {
            return 10
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            let view = UIView()
            view.backgroundColor = bgColor
            return view
        }
        else {
            let view = UIView()
            view.backgroundColor = bgColor
            return view        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
