//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by Владимир on 15.02.2021.
//

import UIKit

class DocumentInfoViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var returnToDocumentButton: UIButton!
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var document: EmojiArtDocument?{
        didSet {
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func updateUI(){
        if sizeLabel != nil, createdLabel != nil,
        let url = document?.fileURL,
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path){
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = shortDateFormatter.string(from: created)
            }
        }
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRatio) //удаляем старый констрейнт
            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0)
            thumbnailImageView.addConstraint(thumbnailAspectRatio)
        }
        
        if presentationController is UIPopoverPresentationController{
            thumbnailImageView?.isHidden = true
            returnToDocumentButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
        
    }
}
