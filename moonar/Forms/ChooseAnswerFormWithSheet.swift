//
//  ChooseAnswerFormWithSheet.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.05.2022.
//

import SwiftUI

struct ChooseAnswerFormWithSheet: View {
	@Binding var color: Color
	@Binding var textColor: Color
	@State private var showSheet = false
	var textOptions: [textOption]
	var sheetView: AnyView
	var exitAction: () -> Void
	
	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 0) {
				ForEach(textOptions) { option in
					if(option.isMain) {
						Button(action: { () -> Void in
							showSheet.toggle()
						}) {
							HStack {
								Spacer()
								Text(option.text)
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
						.foregroundColor(textColor)
						.cornerRadius(15)
						.padding([.horizontal, .bottom])
						.buttonStyle(OnTapButtonState(newTextColor: textColor))
					}
					else {
						Button(action: exitAction) {
							HStack {
								Spacer()
								Text(option.text)
									.font(.title)
									.fontWeight(.bold)
								Spacer()
							}
							.padding(25)
							.background(Color.black)
							.overlay(
								RoundedRectangle(cornerRadius: 15)
									.stroke(color, lineWidth: 15)
							)
						}
						.foregroundColor(Color.white)
						.cornerRadius(15)
						.padding([.horizontal, .bottom])
						.buttonStyle(OnTapButtonState(newTextColor: Color.white))
					}
				}
			}
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

struct ChooseAnswerFormWithSheet_Previews: PreviewProvider {
	static var previews: some View {
		ChooseAnswerFormWithSheet(
			color: .constant(Color.white),
			textColor: .constant(Color.black),
			textOptions: isHavingSymptomsOptions,
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
			exitAction: { () -> Void in }
		)
	}
}
