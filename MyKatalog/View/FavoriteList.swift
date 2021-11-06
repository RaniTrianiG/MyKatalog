//
//  FavoriteList.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 06/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteList: View {
    let coreDM: CoreDataManager
    @State private var games: [FavoriteGames] = [FavoriteGames]()
    private func getAllFavorites(){
        games = coreDM.getAllFavorites()
    }
    
    var body: some View {
        List {
            ForEach(games, id: \.self) { result in
                NavigationLink(destination: KatalogDetail(id: Int(result.id))){
                    VStack(alignment: .leading) {
                        WebImage(url: URL(string: result.background_image ?? ""))
                            .resizable()
                            .indicator(.activity)
                            .cornerRadius(6.0)
                            .transition(.fade(duration: 0.5))
                            .aspectRatio(contentMode: .fill)
                        HStack {
                            Text("Title : ").fontWeight(.bold).font(.system(size: 13))
                            Text(result.name ?? "").font(.system(size: 14))
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("Released : ").fontWeight(.bold).font(.system(size: 13))
                            Text(result.released_date ?? "").font(.system(size: 14))
                        }
                        HStack {
                            Text("Rating :").fontWeight(.bold).font(.system(size: 13))
                            Text(" \(String(result.rating)) / 5").font(.system(size: 14))
                        }
                    }
                }
            }.onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    let game = games[index]
                    coreDM.deleteFavorite(favoriteGames: game)
                    getAllFavorites()
                }
            })
        }.navigationTitle("Favorite List")
            .onAppear(perform: {
                getAllFavorites()
            })
    }
    
}
