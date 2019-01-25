//
//  ChatViewController.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import UIKit

private let kTableViewDefaultInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)

class ChatViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var writeMessageView: UIView!
    @IBOutlet weak var writeMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissKeyboardView: UIView!
    
    let MyMessageCellIdentifier = "MyMessageCell"
    let ParserReplyCellIdentifier = "ParserReplyCell"
    
    fileprivate let chatPresenter = ChatPresenter()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 70
        tableview.contentInset = kTableViewDefaultInsets
        dismissKeyboardView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatPresenter.attach(this: self)
        chatPresenter.onWelcomeMessageRequested()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        writeMessageView.transform = CGAffineTransform(translationX: 0, y: writeMessageView.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spring(delay: 0.1) { [weak self] () -> Void in
            self?.writeMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        chatPresenter.detach(this: self)
    }
    
    // MARK: - Actions
    @IBAction func sendTapped() {
        if messageTextView.text != "" {
            doneEditing()
            if let message = messageTextView.text {
                chatPresenter.onChatMessageSubmitted(messageText: message)
            }
        }
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        doneEditing()
        
        self.tableview.tableViewScrollToLasVisibleCell()
    }
    
    func doneEditing(){
        dismissKeyboardView.isHidden = true
        view.endEditing(true)
    }
    
    func scrollToBottom() {
        // Handle Scrolling
        let numberOfRows = self.chatPresenter.chatMessageItems.count
        let indexPath = NSIndexPath(row: numberOfRows - 1, section: (0))
        self.tableview.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    // MARK: - Keyboard functions.
    @objc func keyboardWillHide(notification: NSNotification) {
        writeMessageBottomConstraint.constant = 0
        dismissKeyboardView.isHidden = true
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        let safeAreaBottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        writeMessageBottomConstraint.constant = safeAreaBottomHeight - keyboardSize.height
        dismissKeyboardView.isHidden = false
        dismissKeyboardView.alpha = 0.1
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
            
            self?.tableview.tableViewScrollToLasVisibleCell()
        })
    }
}

extension ChatViewController: ChatView {
    func startLoading() {
        messageTextView.text = ""
        sendButton.isHidden = true
        sendingActivityIndicator.startAnimating()
        messageTextView.isUserInteractionEnabled = false
    }
    
    func finishLoading() {
        sendButton.isHidden = false
        sendingActivityIndicator.stopAnimating()
        messageTextView.isUserInteractionEnabled = true
    }
    
    func updateChatView() {
        tableview.reloadData()
        self.scrollToBottom()
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatPresenter.chatMessageItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageItem = chatPresenter.chatMessageItems[indexPath.row]
        
        var identifier: String
        if messageItem.type == .mine {
            identifier = MyMessageCellIdentifier
        } else {
            identifier = ParserReplyCellIdentifier
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ChatMessageCell
        
        if messageItem.format == .plainText {
            cell.messageLabel.text = messageItem.message
        } else if messageItem.format == .html{
            let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(cell.messageLabel.font!.pointSize)\">%@</span>" as NSString, messageItem.message ?? "") as String
            
            cell.messageLabel.attributedText = try? NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        } else {
            cell.messageLabel.attributedText = TextUtils.getFormattedText(of: messageItem.parsedMessage)
        }
        
        return cell
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

