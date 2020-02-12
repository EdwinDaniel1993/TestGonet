//
//  DetailViewController.swift
//  TestGonet
//
//  Created by Edwin Daniel on 2/11/20.
//  Copyright © 2020 Edwin Daniel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    
    var info: InfoEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDetailViewController()
    }
    
    func configureDetailViewController(){
        // Change to light color.
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        // Set info in the components.
        self.lblTitle.text = self.info?.title
        self.lblContent.text = self.info?.content
        self.ivImage.image = #imageLiteral(resourceName: "Image_detail")
    }

    

}
