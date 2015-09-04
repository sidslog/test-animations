//
//  CategoryTags.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 26/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class CategoryTags: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchString = ""
    
    private var tags = ["asdasd", "asdasdsad"];
    private var selectedTags = [String]();
    
    
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedCollectionViewHeght: NSLayoutConstraint!
    
    
//    var completion: ((tags: [BMLiveFeedTag]?) -> ())?
    
//    init(selectedTags: [BMLiveFeedTag], completion: ((tags: [BMLiveFeedTag]?) -> ())) {
//        self.selectedTags = selectedTags;
//        self.completion = completion;
//        super.init(nibName: "CategoryTags", bundle: NSBundle.mainBundle());
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = TagCenterFlowLayout();
        self.selectedCollectionView.collectionViewLayout = TagTwoLinesFlowLayout(collectionViewHeightConstraint: self.selectedCollectionViewHeght);
        
        self.collectionView.registerNib(UINib(nibName: "ExternalDocumentTagCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "ExternalDocumentTagCell");
        self.selectedCollectionView.registerNib(UINib(nibName: "ExternalDocumentTagCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "ExternalDocumentTagCell");
        self.collectionView.registerNib(UINib(nibName: "TagSearchHeaderCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "TagSearchHeaderCell");
        
        self.build()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func build() {
//        let db = Registry.db;
//        
//        let predicate = searchString == "" ? NSPredicate(value: true) : NSPredicate(format: "text contains[cd] %@", searchString);
//        let sorts = [NSSortDescriptor(key: "text", ascending: true)];
//        
//        self.tags = db.fetchAll(BMLiveFeedTag.self, predicate: predicate, sorts: sorts);
//        self.collectionView.reloadData();
    }
    
    func updateSearchString(s: String) {
        self.searchString = s;
        self.build();
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3, animations: {[weak self] () -> Void in
            if let this = self {
                this.view.layer.opacity = 0;
            }
            }) {[weak self] (finished) -> Void in
                if let this = self {
                    this.willMoveToParentViewController(nil);
                    this.view.removeFromSuperview();
                    this.removeFromParentViewController();
                    this.didMoveToParentViewController(nil);
                    
//                    if let closure = this.completion {
//                        closure(tags: nil)
//                    }
                    
                }
        }
    }
    
    @IBAction func onApply(sender: AnyObject) {
        self.dismiss();
    }
}


extension CategoryTags: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return tags.count + 1
        } else {
            return self.selectedTags.count;
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            if (indexPath.row > 0) {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExternalDocumentTagCell", forIndexPath: indexPath) as! ExternalDocumentTagCell;
                cell.configure(self.tags[indexPath.row - 1]);
                return cell;
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagSearchHeaderCell", forIndexPath: indexPath) as! TagSearchHeaderCell;
                return cell;
            }
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExternalDocumentTagCell", forIndexPath: indexPath) as! ExternalDocumentTagCell;
            cell.configure(self.selectedTags[indexPath.row]);
            return cell;
        }
        
    }
    
}

extension CategoryTags: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            if (indexPath.row > 0) {
                let cell = NSBundle.mainBundle().loadNibNamed("ExternalDocumentTagCell", owner: nil, options: nil).first! as! ExternalDocumentTagCell;
                cell.configure(self.tags[indexPath.row - 1]);
                return cell.size();
            } else {
                let cell = NSBundle.mainBundle().loadNibNamed("TagSearchHeaderCell", owner: nil, options: nil).first! as! TagSearchHeaderCell;
                var size = cell.size();
                size.width = 1024;
                return size;
            }
        } else {
            let cell = NSBundle.mainBundle().loadNibNamed("ExternalDocumentTagCell", owner: nil, options: nil).first! as! ExternalDocumentTagCell;
            cell.configure(self.selectedTags[indexPath.row]);
            return cell.size();
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 && collectionView == self.collectionView {
            let tag = self.tags[indexPath.row - 1]
            self.selectedTags.append(tag);
            self.selectedCollectionView.reloadData();
        }
    }
    
    
}
