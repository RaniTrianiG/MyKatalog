//
//  KatalogRow.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct KatalogRow: View {
    var results: Result
    
    var body: some View{
        ScrollView{
        VStack{
            WebImage(url: URL(string: results.background_image))
                .resizable()
                .indicator(.activity)
                .cornerRadius(20)
                .transition(.fade(duration: 0.5))
                .frame(width: 280, height: 220, alignment: .center)
            VStack(alignment: .leading, spacing: 0){
                Text("Judul Game: \(results.name)")
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .lineLimit(3)
                Text("Tanggal Rilis: \(results.released)")
                    .font(.system(size: 14))
                    .lineLimit(3)
                Text("Peringkat: \(String(results.rating)) / 5")
                    .font(.system(size: 14))
                    .lineLimit(3)
            }.padding(.leading)
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 8, trailing: 0))
    }
    }
}
