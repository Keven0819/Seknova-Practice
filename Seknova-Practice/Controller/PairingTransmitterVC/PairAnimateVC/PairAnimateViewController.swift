//
//  PairAnimateViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/19.
//

import UIKit

class PairAnimateViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvConection: UIImageView!
    
    // MARK: - Property
    
    weak var delegate: PairAnimateDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setImages()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setImages() {
        var images =  [UIImage]()
        
        for i in 0...1 {
            for num in 0...11 {
                let image = UIImage(named: "connecting_\(num)")!
                images.append(image)
            }
            
            let animatedImage = UIImage.animatedImage(with: images, duration: 2.0)
            imgvConection.image = animatedImage
            
            if i == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.goToTransmitter()
                }
            }
        }
    }
    
    func goToTransmitter() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
        delegate?.animationDidComplete()
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
protocol PairAnimateDelegate: AnyObject {
    func animationDidComplete()
}
