//
//  AdviceScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 27.05.2022.
//

import SwiftUI

struct FullAdvice: View {
	@State var text: String
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 100)
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Image(systemName: "quote.bubble.fill")
						.padding([.top, .leading], 30)
						.padding(.trailing, 10)
						.scaleEffect(1.5)
						.foregroundColor(Color.white)
					Spacer()
				}
				VStack(spacing: 0) {
					Text(text)
						.foregroundColor(Color.white)
						.padding([.vertical, .trailing], 30)
						.font(.title3.weight(.medium))
						.multilineTextAlignment(.leading)
					Spacer()
				}
			}
		}
	}
}

struct AdviceScreen: View {
	let name: String
	@EnvironmentObject var adviceList: AdviceViewModel

    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView() {
				ForEach(adviceList.fetchedEntitiesAsStrings, id: \.self) { text in
					FullAdvice(text: text)
				}

				Color(.clear)
					.frame(height: 300)
			}
		}
		.navigationTitle(name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct AdviceScreen_Previews: PreviewProvider {
    static var previews: some View {
		AdviceScreen(name: "moonar's pieces of advice")
    }
}
