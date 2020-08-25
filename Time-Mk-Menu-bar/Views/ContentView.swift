//
//  ContentView.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/25/20.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import SwiftUI
import AppKit
import SwiftyXMLParser
import SwiftSoup
import URLImage

struct ContentView: View {
    @State private var results = [NewsPiece]()
    
    var body: some View {
        VStack {
            HStack  {
                Text("Тајм.Мк - Топ вести").font(.headline)
                Button(action: {self.loadData()}){
                    Text("Ажурирај вести")
                }
            }
            // use geometry reader to fix list content width
            GeometryReader { gp in
                List(self.results, id: \.title) { item in
                 VStack(alignment: .leading) {
                    //URLImage(URL(string:item.image)!)
                    Text(item.title)
                        .font(.headline).padding(.vertical, 5)
                    Text(item.description).padding(.top, 5)
                 }
                 .frame(width: gp.size.width)   // << here !!
               }
           }
        }.onAppear(perform: {
                self.loadData();
                print("nesho")
            })
        }
    
    
     func loadData() {
        var temp = [NewsPiece]()
        guard let url = URL(string: "https://time.mk/rss/all") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                let xml = XML.parse(data)
                let accessor = xml["rss"]["channel"]["item"]
                for news_piece in accessor {
                    let title = news_piece["title"].text!
                    let description = news_piece["description"].text!
                    do {
                        let doc: Document = try SwiftSoup.parse(description)
                        let image = try doc.select("img").first()!.attr("src")
                        print(news_piece["link"].text)
                        let news_content = try doc.select("td")[1].text()
                        print(news_content)
                            
                    temp.append(
                        NewsPiece(
                            title: title,
                            description: news_content,
                            image: image,
                            article_url: URL(string: "https://google.com")!
                            )
                    )
                        
                    } catch {
                        print("Error scraping...")
                    }
                        
                }
                
                DispatchQueue.main.async {
                    // update our UI
                    self.results = temp
                }
                
                return
            }
        

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    
        }.resume()
        
    }

    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
