//
//  About.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI

struct About: View {
        var katalogAbout: KatalogAbout
        
        var body: some View{
            HStack(alignment: .center){
                Image("photo_rani")
                    .resizable()
                    .frame(width: 130, height: 150)
                    .clipShape(Circle())
            }
            VStack(alignment: .center){
                Text(katalogAbout.name)
                    .font(.system(size: 20)).fontWeight(.bold).padding(10)
            }
            VStack(alignment: .leading){
                    Text(katalogAbout.description)
                        .font(.system(size: 14))
                        .lineLimit(3)
                HStack(){
                    Image("ic-github")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    Text("RaniTrianiG")
                        .font(.system(size: 15))
                }
            }
            Spacer()
        }
    }


