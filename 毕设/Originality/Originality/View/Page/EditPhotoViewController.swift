//
//  EditPhotoViewController.swift
//  Originality
//
//  Created by suze on 16/2/18.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class EditPhotoViewController: BaseViewController {

    var photoView:UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.frame = CGRect(x: 20, y: 74, width: screenWidth - 40, height: screenHeight - 94)
        
        self.view.addSubview(photoView)
        
        self.title = "编辑图片"
        setNavigationItem("下一步", selector: "doRight", isRight: true)
        setNavigationItem(cancel, selector: "doBack", isRight: false)
        
        
        // Do any additional setup after loading the view.
    }

    
    override func doRight()
    {
        
        let page = EditTitleViewController()
        page.photoView.image = photoView.image
        self.navigationController?.pushViewController(page, animated: true)
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
