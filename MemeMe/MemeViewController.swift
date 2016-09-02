//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Javier Mendoza on 29/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Detail"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .Plain,
            target: self,
            action: #selector(editMeme(_:))
        )
        
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView!.image = meme.memeImage
        self.tabBarController!.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController!.tabBar.hidden = false
    }
    
    func editMeme(sender: UIBarButtonItem){
        performSegueWithIdentifier("editSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let memeEditorController = segue.destinationViewController as! MemeEditorViewController
        memeEditorController.meme=meme
    }
    
}
