//
//  OrderExecutionView.swift
//  Zenith Trading
//
//  Created by Samyack on 09/06/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderExecutionView: View {
    var onDone: () -> Void
    var body: some View {
        NavigationStack {
            VStack{
                AnimatedImage(name: "success.gif")
                    .resizable()
                    .scaledToFit()
                Text("Order Executed Successfully")
                    .font(.largeTitle.bold())
            }
            .navigationBarBackButtonHidden(true)
        }
       
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ) {
                onDone()
            }
        }
    }
}
//
//#Preview {
//    OrderExecutionView()
//}
