//
//  ViewController.swift
//  GCDApp
//
//  Created by Фаддей Гусаров on 26.01.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = ""
        counter()

    }
    
    fileprivate func counter() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "LabelQueue", qos: .unspecified, attributes: .concurrent)
        let workItem = DispatchWorkItem {
            for _ in 0...10 {
                DispatchQueue.main.async {
                    self.label.text?.append("O")
                }
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            group.enter()
            queue.async(group: group, execute: workItem)
            group.leave()
            
        }
    }

}

