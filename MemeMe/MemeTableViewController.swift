//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Javier Mendoza on 29/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        updateMemes()
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateMemes()
        tableView.reloadData()
    }
    
    func updateMemes(){
        memes=(UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MemeTableViewCellController = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! MemeTableViewCellController
        
        let meme = memes[indexPath.row]
        
        cell.memeImageView?.image=meme.memeImage
        cell.memeLabel?.text=meme.topText!+"..."+meme.bottomTextString!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            memes.removeAtIndex(indexPath.row)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes=memes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func createMeme(sender: UIBarButtonItem) {
        presentMemeEditor()
    }
    
    func presentMemeEditor() {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }

}
