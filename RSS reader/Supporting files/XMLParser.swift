//
//  XMLParser.swift
//  RSS reader
//
//  Created by Дмитрий on 30.10.2020.
//

import Foundation
import UIKit

class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [News] = []
    private var rssItem: News!
    private var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentFullText: String = "" {
        didSet {
            currentFullText = currentFullText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCategory: String = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImage: String = "" {
        didSet {
            currentImage = currentImage.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([News]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([News]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        
        
        let task = urlSession.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentFullText = ""
            currentPubDate = ""
            currentCategory = ""
            
        }
        if currentElement == "enclosure" {
            let attrsUrl = attributeDict as [String: NSString]
            let urlPic = attrsUrl["url"]
            currentImage = urlPic! as String
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "yandex:full-text" : currentFullText += string
        case "pubDate" : currentPubDate += string
        case "category" : currentCategory += string
        case "enclosure" : currentImage += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            
            let imageURL = URL(string: (currentImage.components(separatedBy: "string(\"").last?.components(separatedBy: "\")").first) ?? "nil")
            if let url = imageURL, let imageData = try? Data(contentsOf: url) {
                rssItem = News(title: currentTitle, publicationDate: currentPubDate, category: currentCategory, fullText: currentFullText, image: UIImage(data: imageData))
            } else {
                rssItem = News(title: currentTitle, publicationDate: currentPubDate, category: currentCategory, fullText: currentFullText)
            }
            self.rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
}
