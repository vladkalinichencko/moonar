//
//  ThoughtsScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 27.05.2022.
//

import SwiftUI

struct FullTextThought: View {
	var text: String
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 100)
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
			VStack(spacing: 0) {
				Text(text)
					.foregroundColor(Color.white)
					.padding(30)
					.font(.title3.weight(.medium))
					.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
}

struct TextThoughtsScreen: View {
	let name: String
	@EnvironmentObject var textList: TextThoughtViewModel

    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView() {
				ForEach((0..<Int(textList.fetchedEntitiesAsStrings.count)).reversed(), id: \.self) { i in
					if String(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[1]) != String(textList.fetchedEntitiesAsStrings[min(i + 1, Int(textList.fetchedEntitiesAsStrings.count) - 1)].split(separator: "-")[1]) || i == Int(textList.fetchedEntitiesAsStrings.count) - 1 {
						Text(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[1].description.replacingOccurrences(of: ":", with: "."))
							.padding()
							.font(.title3.weight(.medium))
							.foregroundColor(Color.white)
					}
					
					FullTextThought(text: String(textList.fetchedEntitiesAsStrings[i].split(separator: "-", maxSplits: 5)[5]))
					
					if String(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[4]) == "0" {
						Color(.clear)
							.frame(height: 20)
					}
				}
				
				Color(.clear)
					.frame(height: 300)
			}
		}
		.navigationTitle(name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct TextThoughtsScreen_Previews: PreviewProvider {
    static var previews: some View {
		TextThoughtsScreen(name: "Your Text Thoughts")
    }
}
