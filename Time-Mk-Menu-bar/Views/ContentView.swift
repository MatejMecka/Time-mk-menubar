//
//  ContentView.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/25/20.
//  Copyright © 2020 Matej Plavevski. All rights reserved.
//

import SwiftUI
import AppKit
import SwiftyXMLParser
import SwiftSoup
import URLImage

struct ContentView: View {
    @State private var results = [NewsPiece]()
    @State private var selectedFeed = 0
    @State private var showingAlert = false
    @State private var errorMessage = ""
    var NewsFeedTitles = Array(rss_feeds.orderedKeys)
    //var selectedTitle = rss_feeds[self.NewsFeedTitles[self.selectedFeed]]
    
    var body: some View {
        VStack {
            VStack  {
                Text("Тајм.Мк - Топ вести").font(.headline).padding(.top,10)
                HStack{
                    Picker(selection: $selectedFeed.onChange(updateFeedFromPickerSelection), label: Text("Категорија:").font(.system(size: 12))) {
                         ForEach(0 ..< NewsFeedTitles.count) {
                            Text(self.NewsFeedTitles[$0]).tag($0)
                         }
                    }
                    Button(action: {self.loadData(feed: rss_feeds[self.NewsFeedTitles[self.selectedFeed]]!)}){
                        Text("Освежи вести")
                        .font(.caption)
                        .fontWeight(.semibold)
                    }
                    Button(action: {
                        NSApplication.shared.terminate(self)
                    })
                    {
                        //Image(systemName: "power")
                        Image("Power").resizable().scaledToFit()
                        
                    }
                }.padding(.trailing, 10).padding(.leading, 10)
            }
            // use geometry reader to fix list content width
            GeometryReader { gp in
                List(self.results, id: \.title) { item in
                 VStack(alignment: .leading) {
                    //URLImage(URL(string:item.image)!)
                    Text(item.title)
                        .font(.headline).padding(.vertical, 5)
                    Text(item.description).padding(.top, 5)
                    HStack{
                        Button(action: {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(item.article_url.absoluteString, forType: .string)
                        }){
                            Text("Копирај")
                        }
                        
                        Button(action: {
                            NSWorkspace.shared.open(item.article_url)
                        }){
                            Text("Отвори")
                        }
                    }
                 }.frame(width: gp.size.width)   // << here !!
               }.onAppear(perform: {
                self.loadData(feed: rss_feeds[self.NewsFeedTitles[self.selectedFeed]]!);
               }).alert(isPresented: self.$showingAlert){
                Alert(title: Text("Се случи грешка!"), message: Text(self.errorMessage), dismissButton: .default(Text("Во ред")))
                }
           }
        }
    }
        
    func updateFeedFromPickerSelection(_ tag: Int) {
        // https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
        self.loadData(feed: rss_feeds[self.NewsFeedTitles[tag]]!)
        print("Color tag: \(tag)")
    }
    
    func loadData(feed: String) {
        var temp = [NewsPiece]()
        guard let url = URL(string: feed) else {
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
                        //let image = try doc.select("img").first()!.attr("src")
                        let url = news_piece["link"].text!
                        print(url)
                        let news_content = try doc.select("td")[1].text()
                        print(news_content)
                            
                    temp.append(
                        NewsPiece(
                            title: title,
                            description: news_content,
                            //image: image,
                            article_url: URL(string: url) ?? URL(string: "https://google.com")!
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
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            self.errorMessage = error?.localizedDescription ?? "Непозната грешка"
            self.showingAlert = true
            
        }.resume()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
