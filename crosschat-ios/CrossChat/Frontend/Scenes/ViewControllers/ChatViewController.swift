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
    
    // TODO: - Gaston - Eliminar el chat presenter.
    fileprivate let chatPresenter = ChatPresenter()
    
    private var chatMessagesItems = [ChatMessageItem]()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChatTableView()
        
        self.dismissKeyboardView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chatPresenter.attach(this: self)
        self.chatPresenter.onWelcomeMessageRequested()
        self.createWelcomeMessage()
        
        self.registerAsKeyboardObserver()
        
        writeMessageView.transform = CGAffineTransform(translationX: 0, y: writeMessageView.bounds.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.registerAsKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spring(delay: 0.1) { [weak self] () -> Void in
            self?.writeMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    deinit {
        chatPresenter.detach(this: self)
    }
    
    // MARK: - Messages functions.
    private func createWelcomeMessage() {
        var welcomeChatMessage = ChatMessageItem()
        welcomeChatMessage.message = NSLocalizedString("welcome_message", comment: "")
        welcomeChatMessage.type = .reply
        welcomeChatMessage.format = .html
        welcomeChatMessage.date = Date()
        
        self.chatMessagesItems.append(welcomeChatMessage)
    }
    
    // MARK: - Notifications functions.
    private func registerAsKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeAsKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Chat tableview functions.
    private func setupChatTableView() {
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.estimatedRowHeight = 70
        self.tableview.contentInset = kTableViewDefaultInsets
    }
    
    func scrollToBottom() {
        guard self.chatMessagesItems.count > 0  else {
            return
        }
        
        self.tableview.tableViewScrollToBottom(NSIndexPath(row: self.chatMessagesItems.count - 1, section: (0)))
    }
    
    // MARK: - Actions
    @IBAction func sendTapped() {
        self.doneEditing()
        
        guard let messageText = self.messageTextView.text, self.messageTextView.text.count > 0 else {
            return
        }
        
        self.startLoading()
        
        self.chatMessagesItems.append(messageText.stringGetSelfChatMesage())
        
        self.chatPresenter.onChatMessageSubmitted(messageText: messageText)
    }
    
    // MARK: - Keyboard functions.
    @objc func keyboardWillHide(notification: NSNotification) {
        self.writeMessageBottomConstraint.constant = 0
        self.dismissKeyboardView.isHidden = true
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        let safeAreaBottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        self.writeMessageBottomConstraint.constant = safeAreaBottomHeight - keyboardSize.height
        self.dismissKeyboardView.isHidden = false
        self.dismissKeyboardView.alpha = 0.1
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
            
            self?.tableview.tableViewScrollToLastVisibleCell()
        })
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.doneEditing()
        self.tableview.tableViewScrollToLastVisibleCell()
    }
    
    func doneEditing() {
        self.dismissKeyboardView.isHidden = true
        self.view.endEditing(true)
    }
}

extension ChatViewController: ChatView {
    func startLoading() {
        self.messageTextView.text = ""
        self.sendButton.isHidden = true
        self.sendingActivityIndicator.startAnimating()
        self.messageTextView.isUserInteractionEnabled = false
    }
    
    func finishLoading() {
        self.sendButton.isHidden = false
        self.sendingActivityIndicator.stopAnimating()
        self.messageTextView.isUserInteractionEnabled = true
    }
    
    func updateChatView() {
        self.tableview.reloadData()
        self.scrollToBottom()
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessagesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageItem = self.chatMessagesItems[indexPath.row]
        
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

