#import "../lib.typ": *
#show: deck
#set document(title: "Academic Template — examples")

#title-slide(
  [A Minimal Template for Research Talks],
  [Reusable structure for academic presentations],
  [Your name],
  affiliation: [Your research group],
  note: [A Typst template for paper discussions and seminars],
)
#pagebreak()

#section-slide("design", index: 1, topic: [Reusable page components], title-size: 42,
  claim: [One visual system, reused across the entire research talk.])[
  #heading(60, 125, 390, [A consistent reading order])
  #panel(60, 190, 390, 58, fill: rgb("F3F6F8"), stroke: 0.7pt + rgb("AAAAAA"))
  #textbox(80, 205, 350, [1. Evidence], size: 24)
  #panel(60, 275, 390, 58, fill: rgb("F3F6F8"), stroke: 0.7pt + rgb("AAAAAA"))
  #textbox(80, 290, 350, [2. Interpretation], size: 24)
  #panel(60, 360, 390, 58, fill: rgb("EAF2FA"), stroke: 0.7pt + style.blue)
  #textbox(80, 375, 350, [3. Takeaway], size: 24, fill: style.blue, weight: "bold")
  #heading(510, 125, 390, [Fixed chapter headings])
  #textbox(510, 174, 390, [Requirements, designs and experiments follow the same structure.], size: 23)
  #heading(510, 300, 390, [Evidence before conclusions])
  #textbox(510, 349, 390, [Keep the figure readable. Explain its meaning. Close with one clear takeaway.], size: 23)
]
