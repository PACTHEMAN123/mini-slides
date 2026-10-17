#import "lib.typ": *
#show: deck
#let system-name = "Research System"

#title-slide(
  [Paper title: the central contribution],
  [A short subtitle for the research talk],
  [Author One, Author Two, Author Three],
  affiliation: [Research group / University],
  note: [Seminar · 2026],
)
#pagebreak()

#section-slide("background", topic: [Research setting], title-size: 42)[
  #heading(60, 123, 840, [Research context])
  #textbox(60, 170, 840, [Introduce the setting, terminology and decision being studied.])
  #heading(60, 270, 840, [Problem scope])
  #textbox(60, 317, 840, [Define the unit of analysis and the assumptions that bound the work.])
  #takeaway([State why the research problem matters.])
]
#pagebreak()

#section-slide("characterization", title-size: 42)[
  #heading(60, 123, 840, [Observations and requirements])
  #bullets(60, 195, 800, (
    [Observation 1 motivates the first requirement.],
    [Observation 2 motivates the second requirement.],
  ), size: 24, gap: 24)
  #takeaway([Connect the observations to the requirements for the method.])
]
#pagebreak()

#section-slide("requirement", index: 1, topic: [First requirement], title-size: 42)[
  #panel(60, 125, 510, 302, fill: rgb("F3F6F8"), stroke: 0.7pt + rgb("AAAAAA"))
  #textbox(100, 230, 430, [Evidence for this requirement], size: 25)
  #heading(592.5, 123, 307.5, [Observation])
  #textbox(592.5, 170, 307.5, [Describe what the evidence shows.])
  #heading(592.5, 285, 307.5, [Implication])
  #textbox(592.5, 332, 307.5, [Explain what the method must support.])
  #takeaway([State the first requirement as the conclusion of this evidence.])
]
#pagebreak()

#section-slide("requirement", index: 2, topic: [Second requirement], title-size: 42)[
  #heading(60, 123, 840, [Supporting evidence])
  #textbox(60, 175, 840, [Use another observation that motivates a distinct requirement.])
  #heading(60, 280, 840, [Design implication])
  #textbox(60, 332, 840, [Explain why the first requirement alone is insufficient.])
  #takeaway([State the second requirement and its relationship to the first.])
]
#pagebreak()

#section-slide("approaches", title-size: 42)[
  #heading(60, 123, 390, [Existing approach A])
  #textbox(60, 170, 390, [Describe its main strength and the requirement it leaves unresolved.])
  #heading(510, 123, 390, [Existing approach B])
  #textbox(510, 170, 390, [Describe its main strength and the requirement it leaves unresolved.])
  #heading(60, 310, 840, [The joint challenge])
  #textbox(60, 357, 840, [State the unresolved tension that motivates the proposed method.])
  #takeaway([Explain why satisfying all requirements needs a new design.])
]
#pagebreak()

#section-slide("overview", system: system-name, title-size: 40)[
  #panel(60, 125, 840, 200, fill: rgb("F3F6F8"), stroke: 0.7pt + rgb("AAAAAA"))
  #textbox(110, 205, 740, [System diagram: inputs, components, outputs], size: 25)
  #heading(60, 360, 390, [Design 1: First mechanism])
  #textbox(60, 405, 390, [Its role in addressing the requirements.])
  #heading(510, 360, 390, [Design 2: Second mechanism])
  #textbox(510, 405, 390, [How it uses or complements the first mechanism.])
]
#pagebreak()

#two-column-slide(section-title("design", index: 1, topic: [First mechanism]), [
  #text(fill: style.blue, weight: "bold")[Inputs and assumptions]
  #v(12pt)
  Define the inputs and the output this component provides.
  #v(35pt)
  #text(fill: style.blue, weight: "bold")[Core idea]
  #v(12pt)
  Explain the mechanism with a diagram or a short equation.
], [
  #text(fill: style.blue, weight: "bold")[Why this design is needed]
  #v(12pt)
  Connect the mechanism to a requirement introduced earlier.
  #v(35pt)
  #text(fill: style.blue, weight: "bold")[Interface to the next component]
  #v(12pt)
  State how the next part uses this output.
], claim: [State what the first mechanism enables.])
#pagebreak()

#section-slide("design", index: 2, topic: [Second mechanism], title-size: 42)[
  #heading(60, 123, 840, [Decision process])
  #bullets(60, 190, 800, (
    [State the input from the first mechanism.],
    [Explain the transformation or decision rule.],
    [Specify the output and the boundary conditions.],
  ), gap: 18)
  #takeaway([State how this mechanism completes the design.])
]
#pagebreak()

#section-slide("setup", title-size: 48)[
  #heading(60, 123, 390, [Study configuration])
  #textbox(60, 170, 390, [Models or study subjects\
    Data and workloads\
    Hardware or experimental environment], leading: 10)
  #heading(510, 123, 390, [Comparison protocol])
  #textbox(510, 170, 390, [Baselines\
    Metrics and aggregation\
    Controlled conditions and parameter settings], leading: 10)
  #takeaway([Specify the conditions under which the following evidence is valid.])
]
#pagebreak()

#section-slide("end-to-end", topic: [Overall performance], title-size: 42)[
  #panel(60, 125, 510, 302, fill: rgb("F3F6F8"), stroke: 0.7pt + rgb("AAAAAA"))
  #textbox(100, 230, 430, [Main comparison figure], size: 25)
  #caption(60, 438, 510, [Source, conditions, units and aggregation])
  #heading(592.5, 123, 307.5, [Measured result])
  #textbox(592.5, 170, 307.5, [Give the effect size and the exact comparison.])
  #heading(592.5, 285, 307.5, [Interpretation])
  #textbox(592.5, 332, 307.5, [Explain whether the overall objective is met.])
  #takeaway([Put the main experimental finding here, not in the page title.])
]
#pagebreak()

#section-slide("ablation", topic: [Mechanism contribution], title-size: 42)[
  #heading(60, 123, 840, [Controlled comparison])
  #textbox(60, 175, 840, [State what stays fixed, what changes, and which metric tests the mechanism.])
  #heading(60, 280, 840, [Evidence and interpretation])
  #textbox(60, 332, 840, [Show whether the change supports the mechanism's intended role.])
  #takeaway([State the mechanism contribution within the tested conditions.])
]
#pagebreak()

#section-slide("conclusion", title-size: 42)[
  #heading(60, 123, 840, [Problem insight])
  #textbox(60, 170, 840, [Summarize the observations and the resulting requirements.])
  #heading(60, 270, 840, [Core designs])
  #textbox(60, 317, 840, [Explain how the mechanisms address the identified challenge.])
  #heading(60, 410, 840, [Evaluation and boundary])
  #textbox(60, 452, 840, [Give the main result together with its scope and limitation.])
]
#pagebreak()

#section-slide("appendix", topic: [References], title-size: 42)[
  #heading(60, 123, 840, [Primary paper])
  #textbox(60, 175, 840, [Add the complete paper citation and a stable link.])
  #heading(60, 280, 840, [Other sources cited in the presentation])
  #textbox(60, 332, 840, [List the references actually used in the slides.])
]
