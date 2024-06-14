//
//  ContentView.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.accentColor)
                Image(systemName: "lasso.and.sparkles")
                    .font(.system(size: 60))
            }.padding(.bottom)
            Text("LAAAST")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 1.0)
            Text("Get your excitement back on track.")
                .foregroundColor(Color.gray)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
