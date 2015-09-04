//
//  CardViewController.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 14/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class Card: NSObject {
    let name: String!
    init(name: String) {
        self.name = name;
        super.init();
    }
}

@objc class TestView: UIView {
    deinit {
        println("deinit!!!");
    }
}

class CardViewController: UIViewController {

    let card : Card!;
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    deinit {
        println("vc deinit");
    }
    
    init(card: Card) {
        self.card = card;
        super.init(nibName: "CardViewController", bundle: NSBundle.mainBundle());
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        self.nameLabel.text = card.name;
        
        
        self.nameLabel.superview?.layer.borderColor = UIColor.blackColor().CGColor;
        self.nameLabel.superview?.layer.borderWidth = 1;
        // Do any additional setup after loading the view.
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
    @IBAction func onDelete(sender: AnyObject) {
        if let parent = self.parentViewController as? SlideViewController {
            parent.cards.removeAtIndex(parent.currentIndex);
            parent.removeCurrentAnimated(false);
        }
    }

    @IBAction func onLeftLeft(sender: AnyObject) {
        
        self.insertName("leftleft", diff: -2);
    }

    @IBAction func onLeft(sender: AnyObject) {
        self.insertName("left", diff: -1);
    }
    
    @IBAction func onCenter(sender: AnyObject) {
        self.insertName("center", diff: 0);
    }
    
    @IBAction func onRight(sender: AnyObject) {
        self.insertName("right", diff: 1);
    }
    
    @IBAction func onRightRight(sender: AnyObject) {
        self.insertName("rightright", diff: 2);
    }
    
    @IBAction func onPrev(sender: AnyObject) {
        self.insertName("prev", diff: -3);
    }
    
    @IBAction func onNext(sender: AnyObject) {
        self.insertName("next", diff: 3);
    }
    
    
    func insertName(name: String, diff: Int) {
        let card = Card(name: name);
        if let parent = self.parentViewController as? SlideViewController {
            
            let index = parent.currentIndex;
            let newIndex = index + diff;
            
            parent.cards.insert(card, atIndex: newIndex);
            parent.insertAnimated(newIndex);
        }

    }
    
}
