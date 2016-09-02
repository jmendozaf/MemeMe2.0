//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Javier Mendoza on 29/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes: [Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeFlowLayout(UIDevice.currentDevice().orientation)
        self.edgesForExtendedLayout = UIRectEdge.None
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateMemes()
        collectionView.reloadData()
        changeFlowLayout(UIDevice.currentDevice().orientation)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        changeFlowLayout(UIDevice.currentDevice().orientation)
    }
    
    func changeFlowLayout(orientation: UIDeviceOrientation) {
        
        let space: CGFloat = 3.0
        let dimension = orientation.isPortrait
            ? (self.view.frame.size.width - (2 * space)) / 3
            : (self.view.frame.size.width - (4 * space)) / 5
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    func updateMemes(){
        memes=(UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let destination = segue.destinationViewController as! MemeViewController
        let index = sender as! NSIndexPath
        
        destination.meme = memes[index.row]
        
    }


    
    @IBAction func createMeme(sender: UIBarButtonItem) {
        presentMemeEditor()
    }
    
    func presentMemeEditor() {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }

    
}
