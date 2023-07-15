//
//  TypeInForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 09.04.2022.
//

import SwiftUI

struct TypeInForm: View {
	@Binding var text: String
	@Binding var color: Color
	@Binding var textColor: Color
	var action: () -> Void
	
    var body: some View {
		VStack {
			Spacer()
			HStack(spacing: 0) {
				TextField("", text: $text)
					.padding(20)
					.foregroundColor(.white)
					.font(.title.weight(.bold))
					.background(
						RoundedRectangle(cornerRadius: 15)
							.stroke(color, lineWidth: 15)
							.background(Color.black)
					)
					.cornerRadius(15)
					.padding(.leading)
				
				Button(action: {
					if text != "" {
						action()
					}
				}) {
					HStack {
						Image(systemName: "arrow.up")
							.font(.title.weight(.bold))
							.frame(width: 30, height: 30)
					}
					.padding(20)
					.background(color)
				}
				.foregroundColor(textColor)
				.cornerRadius(15)
				.padding()
				.buttonStyle(OnTapButtonState(newTextColor: textColor))
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

struct TypeInForm_Previews: PreviewProvider {
    static var previews: some View {
		TypeInForm(text: .constant("Vlad"), color: .constant(Color.white), textColor: .constant(Color.black), action: { () -> Void in })
    }
}
