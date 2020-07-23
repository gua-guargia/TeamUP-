//
//  KolodaViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 24/6/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import Koloda
import pop
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class KolodaViewController: UIViewController {

  var db:Firestore!
    @IBOutlet weak var kolodaView: KolodaView!
    var ProjectArray = [Project]()
    var passInfo = kolodaReader(name: "", type: "", status: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // kolodaView.layer.cornerRadius = 20
       // kolodaView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
      //  kolodaView.dataSource = self
       // kolodaView.delegate = self
        print("\(passInfo)")
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = KolodaViewAnimator(koloda: kolodaView)
        
        db = Firestore.firestore()
        //loadData()
        checkForUpdates()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        
    }
    @IBAction func revertButton(_ sender: Any) {
        kolodaView?.revertAction()
        print(ProjectArray.count)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 func loadData() {
       db.collection("projects").getDocuments() {
           querySnapshot, error in
           if let error = error {
               print("\(error.localizedDescription)")
           }else{
            self.ProjectArray = querySnapshot!.documents.compactMap({Project(dictionary: $0.data())})
            }
               DispatchQueue.main.async {
                   self.kolodaView.reloadData()
               }
           }
       }
   
   func checkForUpdates() {
       db.collection("projects")
           .addSnapshotListener(includeMetadataChanges: true) {
               querySnapshot, error in
               
               guard let snapshot = querySnapshot else {return}
               
               snapshot.documentChanges.forEach {
                   diff in
                   
                   if diff.type == .added {
                       self.ProjectArray.append(Project(dictionary: diff.document.data())!)
                       DispatchQueue.main.async {
                           self.kolodaView.reloadData()
                       }
                   }
               }
               
       }
   }
}

    extension KolodaViewController: KolodaViewDelegate {
        func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
            kolodaView.resetCurrentCardIndex()
        }

        func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
           let alert = UIAlertController(title: "Congratulation!", message: "You're now matched", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alert, animated: true)
        }
        
        func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
            return true
        }
        
        func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
            return false
        }
        
        func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
            return true
        }
        
        func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
            let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            animation?.springBounciness = frameAnimationSpringBounciness
            animation?.springSpeed = frameAnimationSpringSpeed
            return animation
        }
        
         func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
            if(direction == .right){
                let alert = UIAlertController(title: nil , message: nil, preferredStyle: .alert)
               // alert.addAction(UIAlertAction(title: "OK", style: .default))
                var imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
                imageView.image = #imageLiteral(resourceName: "tick")
                alert.view.addSubview(imageView)
                let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                alert.view.addConstraint(height)
                alert.view.addConstraint(width)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    // your actions here...
                }))
                self.present(alert, animated: true, completion: nil)
                
                let project = self.ProjectArray[index]
                    var Name : String = project.Name
                    var Description : String = project.Description
                    var Organiser : String = project.Organiser
                    var ref: DocumentReference? = nil
                    ref = self.db.collection("users123").document("nPuJKSBpWBtZ4OnCGf1a").collection("Projects").addDocument(data: [
                        "Name": Name,
                        "Description": Description,
                        "Organiser" : Organiser
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                }
            }
}

extension KolodaViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return ProjectArray.count
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
       let view = UILabel()
        print("projectArray")
        view.frame = CGRect.init(x: 0, y: 0, width: 300, height: 300)
        view.text = "\(ProjectArray[index].Name) - \(ProjectArray[index].Description)"
        return view
    }

    /*func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }*/
}
