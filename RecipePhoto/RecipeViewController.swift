//
//  RecipeViewController.swift
//  RecipePhoto
//
//  Created by wentilin on 15/7/8.
//  Copyright (c) 2015年 wentilin. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    
    var recipeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if recipeName != nil {
            recipeImageView.image = UIImage(named: recipeName!)
        }
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
