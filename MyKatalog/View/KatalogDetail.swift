//
//  KatalogDetail.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct KatalogDetail: View {
    var id : Int
    @State var attributedString: AttributedString?
    @State private var name = "Loading..."
    @State private var description = "Loading..."
    @State private var released = "Loading..."
    @State private var rating = "Loading..."
    @State private var background_image = "Loading..."
    
    var body : some View {
        ScrollView {
            VStack {
                Spacer()
                HStack {
                    Text(name)
                        .font(.system(size: 25))
                        .bold()
                }
                WebImage(url: URL(string: background_image))
                    .resizable()
                    .indicator(.activity)
                    .cornerRadius(6.0)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fill)
                Text("Tanggal Rilis: \(released)")
                    .font(.system(size: 17)).fontWeight(.bold).padding()
                Text("Rating: \(String(rating)) / 5")
                    .font(.system(size: 17)).fontWeight(.bold)
                if let attrString = attributedString {
                    Text(attrString).font(.system(size: 25)).padding(5)
                }
            }
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20  ))
            .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.rawg.io/api/games/\(id)?key=1fdf18c99ab545caba28582363571c25") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ResponseDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.name = decodedResponse.name
                        self.description = decodedResponse.description
                        self.released = decodedResponse.released
                        self.rating = (String(decodedResponse.rating))
                        self.parseHTMLToAttributedString()
                        self.background_image = decodedResponse.background_image
                    }
                } catch DecodingError.keyNotFound(let key, let context) {
                    Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                }
                return
            }
            
        }.resume()
    }
    func parseHTMLToAttributedString() {
        let htmlText = "\(description)"
        let encodedData = htmlText.data(using: String.Encoding.utf8)!
        var attributedString: NSAttributedString
        
        do {
            attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
            DispatchQueue.main.async {
                self.attributedString = AttributedString(attributedString)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error")
        }
        
    }
}
