//
//  GptViewController.swift
//  DaeGPT
//
//  Created by 강민우 on 2023/02/25.
//

import UIKit
import OpenAI

//class GptViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var tableView: UITableView!
//
//    let completion = Completion(apiKey: "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")
//    let completion = Completion(apiKey: "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")
//    var messages: [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        textField.delegate = self
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let text = textField.text {
//            messages.append(text)
//            tableView.reloadData()
//            textField.text = ""
//            completion.createCompletion(prompt: text, maxTokens: 60, callback: { (response, error) in
//                if let response = response {
//                    self.messages.append(response.text)
//                    self.tableView.reloadData()
//                } else {
//                    print(error?.localizedDescription ?? "Unknown error")
//                }
//            })
//        }
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
//        cell.textLabel?.text = messages[indexPath.row]
//        return cell
//    }
//}
