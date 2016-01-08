//
//  Processing.swift
//  ScrollingNavBar
//
//  Created by suze on 15/10/18.
//  Copyright © 2015年 suze. All rights reserved.
//

import Foundation
import TBXML
class Processing: NSObject {
    
    private var songs:NSMutableArray!
    
    func start(){
        print("start")

        self.songs = NSMutableArray()
        var path = NSBundle.mainBundle().pathForResource("Song", ofType: "xml")
        var data = NSData(contentsOfFile: path!)
        let tbxml = try? TBXML(XMLData: data)
       // print(tbxml)
        let root = tbxml!.rootXMLElement
        print("\(root)")

        if root != nil {
            print("b")
            var noteElement = TBXML.childElementNamed("Song",parentElement: root)
            while noteElement != nil {
                print("c")
                let dict = NSMutableDictionary()
                let TitleElement = TBXML.childElementNamed("Title",parentElement: noteElement)
                if TitleElement !=  nil {
                    let Title = TBXML.textForElement(TitleElement)
                    print("\(Title)")
                    dict.setValue(Title, forKey: "title")
                }
                let SingerElement = TBXML.childElementNamed("Singer",parentElement: noteElement)
                if SingerElement !=  nil {
                    
                    let Singer = TBXML.textForElement(SingerElement)
                    dict.setValue(Singer, forKey: "singer")
                }
                
                let DateElement = TBXML.childElementNamed("Date",parentElement: noteElement)
                if DateElement !=  nil {
                    
                    let Date = TBXML.textForElement(DateElement)
                    dict.setValue(Date, forKey: "date")
                }
                
                let ContentElement = TBXML.childElementNamed("Content",parentElement: noteElement)
                if ContentElement != nil {
                    let Content = TBXML.textForElement(ContentElement)
                    dict.setValue(Content, forKey: "content")
                }
                
                let MvElement = TBXML.childElementNamed("Mv",parentElement: noteElement)
                if MvElement != nil {
                    let Mv = TBXML.textForElement(MvElement)
                    dict.setValue(Mv, forKey: "mv")
                }
                
                let id = TBXML.valueOfAttributeNamed("id",forElement: noteElement)
                dict.setValue(id, forKey: "id")
                
            //    print("\(dict)")
                self.songs.addObject(dict)
                
                
                noteElement = TBXML.nextSiblingNamed("Song",searchFromElement: noteElement)
            }
        }
        
        NSLog("解析完成")
        //print("\(self.songs)")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadViewNotification", object: self.songs)
        self.songs = nil
    }
}
