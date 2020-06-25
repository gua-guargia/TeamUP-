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

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class KolodaViewController: UIViewController {

  
    @IBOutlet weak var kolodaView: KolodaView!
    let images = ["Dr Strange", "Thor", "Iron Man", "Spider"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // kolodaView.layer.cornerRadius = 20
       // kolodaView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
      //  kolodaView.dataSource = self
       // kolodaView.delegate = self
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = KolodaViewAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        
    }
    @IBAction func revertButton(_ sender: Any) {
        kolodaView?.revertAction()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    extension KolodaViewController: KolodaViewDelegate {
        func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
            kolodaView.resetCurrentCardIndex()
        }

        func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
           let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(images[index])", preferredStyle: .alert)
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
    }

extension KolodaViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return images.count
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
      let view = UIImageView(image: UIImage(named: images[index]))
      view.layer.cornerRadius = 20
      view.clipsToBounds = true
      return view
    }

    /*func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }*/
}
