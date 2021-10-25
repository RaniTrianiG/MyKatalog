//
//  KatalogList.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct KatalogList: View {
    @State private var results = [Result]()
      
    var body: some View{
            List(results, id: \.id){ item in
                    NavigationLink(destination: KatalogDetail(results: item)){
                        KatalogRow(results: item)
                    }
            }.navigationTitle(Text("Katalog Game")).navigationBarItems(
                trailing: NavigationLink(destination: About(katalogAbout: KatalogAbout(id: 1,  photo: "photo_rani", name: "Rani Triani G", description: "Dicoding Submission Studi kasus Katalog Game"))){
                    Image(systemName: "person.fill").foregroundColor(.black)
                }
            )
            .onAppear(perform: loadData)
    }
    func loadData() {
        // Pengecekkan loading view dapat di cek jika menggunakan data berjumlah banyak. Dapat dilakukan dengan mengganti url tanpa menggunakan filter seperti ini : https://api.rawg.io/api/games?key=1fdf18c99ab545caba28582363571c25
            guard let url = URL(string: "https://api.rawg.io/api/games?key=1fdf18c99ab545caba28582363571c25") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                        DispatchQueue.main.async {
                            self.results = decodedResponse.results
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
}
