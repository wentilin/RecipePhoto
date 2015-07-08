//
//  RecipeCollectionViewController.swift
//  RecipePhoto
//
//  Created by wentilin on 15/7/8.
//  Copyright (c) 2015年 wentilin. All rights reserved.
//

import UIKit
import Social

let reuseIdentifier = "Cell"

class RecipeCollectionViewController: UICollectionViewController {

    var recipeImages = []
    var mainDishImages: [String] = []
    var drinkDessertImages: [String] = []
    var seletedRecipes: NSMutableArray = []
    var shareEnabled: Bool = false
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainDishImages = ["egg_benedict.jpg", "full_breakfast.jpg", "ham_and_cheese_panini.jpg", "ham_and_egg_sandwich.jpg", "hamburger.jpg", "instant_noodle_with_egg.jpg", "japanese_noodle_with_pork.jpg", "mushroom_risotto.jpg", "noodle_with_bbq_pork.jpg", "thai_shrimp_cake.jpg", "vegetable_curry.jpg"]
        
        drinkDessertImages = ["angry_birds_cake.jpg", "creme_brelee.jpg", "green_tea.jpg", "starbucks_coffee.jpg", "white_chocolate_donut.jpg"]
        
        recipeImages = [mainDishImages, drinkDessertImages]
        
        let collectionViewLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return recipeImages.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeImages[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipePhotoCell", forIndexPath: indexPath) as! UICollectionViewCell
    
        let recipeImageView = cell.viewWithTag(102) as! UIImageView
        recipeImageView.image = UIImage(named: recipeImages[indexPath.section][indexPath.row] as! String)
        cell.backgroundView = UIImageView(image: UIImage(named: "photo-frame"))
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "photo-frame-selected"))
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableView: UICollectionReusableView
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "RecipeHeader", forIndexPath: indexPath) as! RecipeCollectionHeaderView
            headerView.title.text = "Recipe Group #\(indexPath.section + 1)"
            headerView.backgroundImage.image = UIImage(named: "header_banner.png")
            
            reusableView = headerView
        }else {
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "RecipeFooter", forIndexPath: indexPath) as! UICollectionReusableView
            reusableView = footerView
        }
        
        return reusableView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipePhoto" {
            let indexPaths = self.collectionView?.indexPathsForSelectedItems() as! [NSIndexPath]
            let indexPath = indexPaths.first!
            if let recipeController = segue.destinationViewController as? RecipeViewController {
                    recipeController.recipeName = recipeImages[indexPath.section][indexPath.row] as? String
            }
        }
    }
    
    //选择某张图片
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let seletedRecipe = recipeImages[indexPath.section][indexPath.row] as! String
        seletedRecipes.addObject(seletedRecipe)
    }
    
    //取消选择的图片
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if shareEnabled {
            let deSelectedRecipe = recipeImages[indexPath.section][indexPath.row] as! String
            seletedRecipes.removeObject(deSelectedRecipe)
        }
    }
    
    @IBAction func shareButtonTapped(sender: UIBarButtonItem) {
        if shareEnabled {
            if seletedRecipes.count > 0 {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
                socialController.setInitialText("iOS App测试，请忽视！github连接-->")
                for recipePhoto in seletedRecipes {
                    println(recipePhoto)
                    socialController.addImage(UIImage(named: recipePhoto as! String))
                }
                socialController.addURL(NSURL(string: "https://github.com/wentilin/RecipePhoto"))
                self.presentViewController(socialController, animated:true, completion: nil)
            }
            //Deselect all selected image
            for indexPath in self.collectionView!.indexPathsForSelectedItems() {
                self.collectionView?.deselectItemAtIndexPath(indexPath as? NSIndexPath, animated: true)
            }
            
            //Remove all items in selectedRecipes
            seletedRecipes.removeAllObjects()
            
            //change the sharing mode to false
            shareEnabled = false
            self.collectionView!.allowsMultipleSelection = false
            self.shareButton.title = "Share"
        } else {
            println("share")
            shareEnabled = true
            self.collectionView!.allowsMultipleSelection = true
            self.shareButton.title = "Upload"
            self.shareButton.style = UIBarButtonItemStyle.Done
        }
    }
    
}
