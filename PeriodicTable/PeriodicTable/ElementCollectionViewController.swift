//
//  ElementCollectionViewController.swift
//  PeriodicTable
//
//  Created by Tong Lin on 12/21/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ElementCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Element>!
    let emptyNeed = [0,1,3,3,3,3,3,3,3,3,3,3,1,1,1,1,1,0]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UINib(nibName:"ElementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        getData()
        initializeFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
        APIRequestManager.manager.getData(endPoint: "https://api.fieldbook.com/v1/5859ad86d53164030048bae2/elements")  { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                    if let wholeDict = jsonData as? [[String:Any]] {
                        
                        // used to be our way of adding a record
                        // self.allArticles.append(contentsOf:Article.parseArticles(from: records))
                        
                        // create the private context on the thread that needs it
                        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.privateContext
                        
                        moc.performAndWait {
                            for mom in wholeDict {
                                // now it goes in the database
                                
                                let element = NSEntityDescription.insertNewObject(forEntityName: "Element", into: moc) as! Element
                                element.populate(from: mom)
                            }
                            
                            do {
                                try moc.save()
                                
                                moc.parent?.performAndWait {
                                    do {
                                        try moc.parent?.save()
                                    }
                                    catch {
                                        fatalError("Failure to save context: \(error)")
                                    }
                                }
                            }
                            catch {
                                fatalError("Failure to save context: \(error)")
                            }
                            
                        }
                        // start off with everything
                        //self.articles = self.allArticles
                        DispatchQueue.main.async {
                            
                            self.collectionView?.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
    
    func initializeFetchedResultsController() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.managedObjectContext
        
        let request = NSFetchRequest<Element>(entityName: "Element")
        
        let byGroup = NSSortDescriptor(key: "group", ascending: true)
        let byNumber = NSSortDescriptor(key: "number", ascending: true)
        
        request.sortDescriptors = [byGroup, byNumber]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "group", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            print("No sections in fetchedResultsController")
            return 0
        }
        
        return 18 //sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sections = fetchedResultsController.sections else {
//            print("No sections in fetchedResultsController")
//            return 0
//        }
//        let sectionInfo = sections[section]
        
        return 7 //sectionInfo.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElementCollectionViewCell
        
        if emptyNeed[indexPath.section] <= indexPath.row{
            let myElement = fetchedResultsController.object(at: IndexPath(row: (indexPath.row - emptyNeed[indexPath.section]), section: indexPath.section))
            
            cell.myView.elementName.text = myElement.symbol
            cell.myView.elementNum.text = String(myElement.number)
            return cell
        }
        
        cell.myView.elementName.text = ""
        cell.myView.elementNum.text = ""
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
