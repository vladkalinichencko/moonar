//
//  ChooseAnswerForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 08.04.2022.
//

import SwiftUI

struct ChooseAnswerForm: View {
	@Binding var selectedOption: String
	@Binding var color: Color
	@Binding var textColor: Color
	var textOptions: [textOption]
	var action: () -> Void
	
    var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 0) {
				ForEach(textOptions) { option in
					if(option.isMain) {
						Button(action: {
							selectedOption = option.text
							action()
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
						.foregroundColor(textColor)
						.cornerRadius(15)
						.padding([.horizontal, .bottom])
						.buttonStyle(OnTapButtonState(newTextColor: textColor))
					}
					else {
						Button(action: {
							selectedOption = option.text
							action()
						}) {
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

struct ChooseAnswerForm_Previews: PreviewProvider {
    static var previews: some View {
		ChooseAnswerForm(
			selectedOption: .constant("Male"),
			color: .constant(Color.white),
			textColor: .constant(Color.black),
			textOptions: genderOptions,
			action: { () -> Void in }
		)
    }
}
