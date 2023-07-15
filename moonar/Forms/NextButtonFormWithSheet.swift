//
//  NextButtonFormWithSheet.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.05.2022.
//

import SwiftUI

struct NextButtonFormWithSheet: View {
	@Binding var color: Color
	@Binding var textColor: Color
	@State private var showSheet = false
	var sheetView: AnyView
	var text: String
	
	var body: some View {
		VStack {
			Spacer()
			Button(action: { () -> Void in
				showSheet.toggle()
			}) {
				HStack {
					Spacer()
					Text(text)
						.font(.title)
						.fontWeight(.bold)
					
					Spacer()
				}
				.padding(25)
				.background(color)
			}
			.sheet(isPresented: $showSheet, content: {
				sheetView
			})
			.padding()
			.foregroundColor(textColor)
			.buttonStyle(OnTapButtonState(newTextColor: textColor))
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		}
		.transition(.move(edge: .bottom).combined(with: .opacity))
		.zIndex(4)
	}
}

struct NextButtonFormWithSheet_Previews: PreviewProvider {
	static var previews: some View {
		NextButtonFormWithSheet(
			color: .constant(Color.white),
			textColor: .constant(Color.black),
			sheetView:
				AnyView(
					PickUpFormSheet(
						pickUpList: symptomOptions,
						sheetPickedUpValues: .constant([false, false, false]),
						color: .constant(Color.white),
						textColor: .constant(Color.black),
						action: { () -> Void in}
					)
				),
			text: "Next"
		)
	}
}
