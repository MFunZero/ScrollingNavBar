//
//  SearchViewController.swift
//  Originality
//
//  Created by suze on 16/2/17.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate ,UICollectionViewDataSource,UICollectionViewDelegate {

    var searchBar:UISearchBar!
    var collectionView : UICollectionView!
    
    // 所有组件
    var ctrls:[SinglePictureInfo]!
    // 搜索匹配的结果，Table View使用这个数组作为datasource
    var ctrlsel:[SinglePictureInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = bgColor
        
        collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: SearchResultViewLayout())
        collectionView.backgroundColor = bgColor
        self.view.addSubview(collectionView)
        // 起始加载全部内容
        self.ctrlsel = self.ctrls
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "grey_left"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = maincolor
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth - 50, height: 20))

        
        let rightButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightButton
        
        searchBar.delegate = self
        searchBar.showsSearchResultsButton = false
        searchBar.showsScopeBar = false

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // 注册TableViewCell
        self.collectionView.registerClass(UserCollectioncell.self,
            forCellWithReuseIdentifier: "SwiftCell")
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.ctrlsel.count
    
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UserCollectioncell!
        
        if cell == nil {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("SwiftCell", forIndexPath: indexPath) as? UserCollectioncell
            
            if self.ctrls.count != 0 {
                // print("sgData:\(singleData[indexPath.row])")
                
                let sp:SinglePictureInfo = self.ctrlsel[indexPath.row]
                
                cell.filename = sp.url
                cell.titleLabel.text = sp.title
                cell.voteLabel.text = String(sp.upvoteCount)
                cell.commentLable.text = String(sp.commentCount)
                
                
                cell.singlePictureId = sp.objectId
                cell.userId = sp.userId
                cell.tagId = sp.tagId
                
                
                
            }
            
        }
        return cell!
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell:UserCollectioncell = collectionView.cellForItemAtIndexPath(indexPath) as! UserCollectioncell
        
        if  let tag = cell.tagId {
            
            let vc:SinglePictureDetailController = SinglePictureDetailController()
            vc.singlePictureInfo = self.ctrls[tag]
            vc.title = titleForDetail
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    

    

    
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // 没有搜索内容时显示全部组件
        if searchText == "" {
            self.ctrlsel = self.ctrls
        }
        else { // 匹配用户输入内容的前缀(不区分大小写)
            self.ctrlsel = []
            for ctrl in self.ctrls {
                if ctrl.title.containsString(searchText) {
                    self.ctrlsel.append(ctrl)
                }
            }
        }
        // 刷新Table View显示
        self.collectionView.reloadData()
    }
    
    func back(sender:UIBarButtonItem)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    // 搜索代理UISearchBarDelegate方法，点击虚拟键盘上的Search按钮时触发
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
