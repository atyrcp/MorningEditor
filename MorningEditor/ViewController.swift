//
//  ViewController.swift
//  MorningEditor
//
//  Created by alien on 2019/3/26.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var editEventHandler = EditEventHandler(fontButtonContainerView: fontButtonContainerView, colorButtonContainerView: colorButtonContainerView, slider: sizeSlider, colorModeButtons: colorModeButtons)
    lazy var slideViews = [fontMenuButton, fontButtonContainerView, colorMenuButton, colorButtonContainerView, sizeMenuButton, sizeSlider]
    let images = [UIImage]().appendImages(byImageNames: ["flower0", "flower1", "flower2", "flower3", "flower4", "flower5", "flower6", "kid0", "kid1", "kid2", "nature0", "other0", "religion0", "religion1", "religion2", "religion3", "religion4", "religion5", "sun0", "sun1", "sun2", "sun3", "sun4", "sun5", "bird0", "bird1", "bird2", "money0", "money1", "money2", "money3", "money4", "love0", "love1", "love2", "love3", "background0", "background1", "background2", "background3", "background4", "background5", "background6", "meme0", "meme1", "meme2", "meme3", "meme4", "meme5", "meme6", "meme7", "meme8", "meme9", "meme10", "meme11", "meme12", "meme13"])
    var imagePickerController: UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        return pickerController
    }
    
    @IBOutlet weak var topBlankView: UIView!
    @IBOutlet weak var fontMenuButton: SlidableMainButton!
    @IBOutlet weak var fontButtonContainerView: FontButtonContainerView!
    @IBOutlet weak var colorMenuButton: SlidableMainButton!
    @IBOutlet weak var colorButtonContainerView: ColorButtonContainerView!
    @IBOutlet weak var sizeMenuButton: SlidableMainButton!
    @IBOutlet weak var sizeSlider: SizeSlider!
    @IBOutlet var colorModeButtons: [ColorModeButton]!
    @IBOutlet weak var slideViewsStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shouldSlideLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    @IBAction func slideViews(_ sender: SlidableMainButton) {
        //handle slideviews(text attribute selections placed on the top area of the app)
        if sender.didSlide {
            let shouldSlideViews = slideViews.filter( {($0!.frame.origin.y) >= sender.frame.maxY} )
            guard let shouldSlideView = shouldSlideViews.first, let slideMovement = shouldSlideView?.frame.height else {return}
            shouldSlideLayoutConstraint.constant -= slideMovement
            for view in shouldSlideViews {
                let slideView = view as! Slidable
                slideView.slideOut(withMovement: slideMovement)
            }
        } else {
            let shouldSlideViews = slideViews.filter( {($0!.frame.maxY) >= sender.frame.maxY} ).dropFirst()
            guard let shouldSlideView = shouldSlideViews.first, let slideMovement = shouldSlideView?.frame.height else {return}
            shouldSlideLayoutConstraint.constant += slideMovement
            for view in shouldSlideViews {
                let slideView = view as! Slidable
                slideView.slideIn(withMovement: slideMovement)
            }
        }
        sender.didSlide.toggle()
        
        // handle the slide logic of textableLabelView inside imageview and the collectionview
        let imageFrameBeforeUpdate = imageView.getImageRect()
        let originsOfSubviews = editEventHandler.getSubViewOrigins(of: imageView)
        let visibleCellIndex = collectionview.indexPathsForVisibleItems.sorted()
        collectionview.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
        collectionview.scrollToItem(at: visibleCellIndex[visibleCellIndex.count / 2], at: .centeredHorizontally, animated: true)
        self.editEventHandler.didSlideSubViews(of: self.imageView, from: imageFrameBeforeUpdate, from: originsOfSubviews)
    }
    
    @IBAction func changeTextValue(_ sender: SizeSlider) {
        sender.delegate?.didSelect(in: sender, for: .tap)
    }
    
    @IBAction func changeColorMode(_ sender: ColorModeButton) {
        editEventHandler.handleTapEvent(for: sender)
    }
    
    @IBAction func createTextLabel(_ sender: RoundedMainButton) {
        let texableLabelView = TextableLabelView()
        texableLabelView.delegate = self
        editEventHandler.handleTapEvent(for: texableLabelView)
        imageView.addSubview(texableLabelView)
        texableLabelView.label.sizeToFit()
        texableLabelView.frame = texableLabelView.label.frame
    }
    
    @IBAction func resetImage(_ sender: RoundedMainButton) {
        for view in imageView.subviews {
            view.removeFromSuperview()
            editEventHandler.currentTextableLabelView = nil
        }
    }
    
    @IBAction func saveImageToAlbum(_ sender: RoundedMainButton) {
        UIGraphicsBeginImageContextWithOptions(imageView.getImageRect().size, false, 0.0)
        self.view.drawHierarchy(in: CGRect(x: -(imageView.getImageRect().origin.x), y: -(imageView.getImageRect().origin.y), width: self.view.bounds.width, height: self.view.bounds.height), afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return}
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "儲存失敗", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好", style: .default))
            alertController.view.tintColor = .customCgBlue
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "儲存成功", message: "您編輯的圖片已成功儲存至相簿中", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好", style: .default))
            alertController.view.tintColor = .customCgBlue
            present(alertController, animated: true)
        }
    }
    
    @IBAction func selectImageFromAlbum(_ sender: RoundedMainButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePickerController.sourceType = .savedPhotosAlbum
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    //make viewcontroller self as the controll center, all attribute selections must go through it before changing the attribute of the current textableLabelView
    private func assignButtonDelegate() {
        fontButtonContainerView.returnSubviews().map( {$0 as! FontSelectionButton} ).forEach( {$0.delegate = self} )
        colorButtonContainerView.returnSubviews().map( {$0 as! ColorSelectionButton} ).forEach( { $0.delegate = self } )
        sizeSlider.delegate = self
    }
    
    private func setupViews() {
        imageView.image = UIImage(named: "flower0")
        self.view.backgroundColor = .customGainsBoro
        //arrange the order of subviews
        slideViewsStackView.bringSubviewToFront(sizeSlider)
        slideViewsStackView.bringSubviewToFront(colorButtonContainerView)
        slideViewsStackView.bringSubviewToFront(fontButtonContainerView)
        slideViewsStackView.bringSubviewToFront(sizeMenuButton)
        slideViewsStackView.bringSubviewToFront(colorMenuButton)
        slideViewsStackView.bringSubviewToFront(fontMenuButton)
        self.view.bringSubviewToFront(topBlankView)
    }
    
    private func settingCustomCollectionviewFlowLayout() {
        let customLayout = CustomCollectionViewFlowLayout()
        customLayout.scrollDirection = .horizontal
        collectionview.collectionViewLayout = customLayout
        collectionview.backgroundColor = .customGainsBoro
        collectionview.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        assignButtonDelegate()
        settingCustomCollectionviewFlowLayout()
    }
}

extension ViewController: GestureRespondDelegate {
    
    func didSelect(in view: GestureRespondable, for event: GestureEvent) {
        
        switch event {
            
        case .tap:
            editEventHandler.handleTapEvent(for: view)
            switch view {
            case is TextableLabelView:
                let textableView = view as! TextableLabelView
                self.view.bringSubviewToFront(textableView)
                //after tapping the textableLabelView, the attribute selection(font, color, size) buttons should slide out
                let menuButtons = [fontMenuButton, colorMenuButton, sizeMenuButton]
                if textableView.isInTextMode {
                    self.view.isUserInteractionEnabled = false
                    for button in menuButtons {
                        if button!.didSlide {
                            slideViews(button!)
                        }
                    }
                    for button in colorModeButtons {
                        button.cancelHighLight()
                    }
                } else {
                    self.view.isUserInteractionEnabled = true
                    for button in menuButtons {
                        slideViews(button!)
                    }
                }
            default:
                break
            }
            
        case .pan:
            editEventHandler.handlePanEvent(for: view)
        default:
            break
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCollectionViewCell {
            cell.displayView(using: images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        self.imageView.image = image
        collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionviewHeight = collectionView.frame.height
        return CGSize(width: collectionviewHeight, height: collectionviewHeight)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}
