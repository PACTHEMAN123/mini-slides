// Reusable academic slide style. Canvas coordinates and sizes are in PDF pt.
// No package registry access is needed (Typst >= 0.11.1).
#let style = (
  width: 960pt, height: 540pt, margin: 60pt,
  font: "Gill Sans MT", blue: rgb("2E7BC4"), ink: black,
  title: 48pt, heading: 22pt, body: 20pt, caption: 14pt,
)

#let deck(body) = {
  set document(title: "Academic research presentation")
  set page(width: style.width, height: style.height, margin: 0pt,
    fill: white, numbering: none)
  set text(font: style.font, size: style.body, fill: style.ink,
    lang: "en", kerning: false, ligatures: false, hyphenate: false)
  set par(leading: 4pt)
  body
}

// One fixed-size canvas; all content stays editable Typst content.
#let canvas(body) = block(width: style.width, height: style.height, clip: true)[#body]
#let at(x, y, body) = place(top + left, dx: x * 1pt, dy: y * 1pt, body)

// Explicit baseline placement preserves PowerPoint's line breaks when tracing.
// For new prose use textbox/heading/bullets instead.
#let baseline(x, y, body, size: 20, weight: "regular", fill: black,
  font: style.font, italic: false) = at(x, y,
  text(font: font, size: size * 1pt, weight: weight, fill: fill,
    style: if italic { "italic" } else { "normal" },
    top-edge: 0pt, bottom-edge: 0pt, body))

// Optional reference tracing: PowerPoint applies its own glyph spacing.
// If the line is edited, automatically fall back to regular Typst text layout.
// New talks do not need this function or any reference metrics.
#let traced-line(x, y, body, metrics, size: 20, weight: "regular",
  fill: black, font: style.font, italic: false) = {
  if body == metrics.text {
    for (i, ch) in body.clusters().enumerate() {
      baseline(x + metrics.offsets.at(i), y, ch, size: size,
        weight: weight, fill: fill, font: font, italic: italic)
    }
  } else {
    baseline(x, y, body, size: size, weight: weight, fill: fill,
      font: font, italic: italic)
  }
}

#let textbox(x, y, w, body, size: 20, weight: "regular", fill: black,
  leading: 4, align-to: left) = at(x, y, block(width: w * 1pt)[
    #set text(size: size * 1pt, weight: weight, fill: fill,
      top-edge: "ascender", bottom-edge: "descender")
    #set par(leading: leading * 1pt)
    #align(align-to, body)
  ])

#let panel(x, y, w, h, fill: none, stroke: none, radius: 0) = at(x, y, rect(width: w * 1pt, height: h * 1pt, fill: fill,
    stroke: stroke, radius: radius * 1pt))

#let figure(x, y, w, h, source, crop: (0, 0, 0, 0)) = {
  // Crop values: left, top, right, bottom fractions, as in DrawingML.
  let (l, t, r, b) = crop
  let iw = w / (1 - l - r)
  let ih = h / (1 - t - b)
  at(x, y, block(width: w * 1pt, height: h * 1pt, clip: true)[
    #place(top + left, dx: -l * iw * 1pt, dy: -t * ih * 1pt,
      image(source, width: iw * 1pt, height: ih * 1pt, fit: "stretch"))
  ])
}

#let heading(x, y, w, body, size: 22) = textbox(x, y, w, body, size: size, weight: "bold", fill: style.blue)
#let caption(x, y, w, body) = textbox(x, y, w, body, size: 14, fill: rgb("666666"))
#let bullets(x, y, w, items, size: 20, gap: 8) = textbox(x, y, w, {
  set list(indent: 10pt, body-indent: 8pt, spacing: gap * 1pt)
  list(..items)
}, size: size)

#let takeaway(body, blue: true, y: 489, size: 20) = {
  if blue {
    panel(0, y, 960, 28.5, fill: style.blue)
    baseline(60, y + 21, body, size: size, weight: "bold", fill: white)
  } else {
    textbox(60, y, 840, body, size: size, weight: "bold")
  }
}

#let frame(title, number: auto, title-size: 48) = {
  // Title x=60, first baseline y=65.52 at 48pt.
  let title-y = if title-size == 48 {65.52} else if title-size == 42 {59.52} else if title-size == 40 {57.6} else {19.5 + title-size * 0.95875}
  baseline(60, title-y, title, size: title-size)
  panel(0, 96, 960, 1.5, fill: black)
  let n = if number == auto { counter(page).display() } else { number }
  baseline(868, 530.88, box(width: 32pt, align(right, n)), size: 12, fill: rgb("777777"))
}

#let slide(title, body, number: auto, title-size: 48, claim: none) = canvas[
  #frame(title, number: number, title-size: title-size)
  #body
  #if claim != none { takeaway(claim) }
]

// Canonical paper-talk headings. New talks use this registry rather than claims
// as page titles. Findings belong in body text and the takeaway strip.
#let section-title(kind, topic: none, index: none, system: none) = {
  let fixed = (
    characterization: "Workload characterization",
    approaches: "Existing approaches and challenges",
    setup: "Experimental setup",
    production: "Production deployment at scale",
    conclusion: "Contributions and takeaways",
    references: "References",
  )
  if kind in fixed {
    assert(topic == none and index == none and system == none,
      message: "This section has a fixed title; do not supply a custom heading.")
    fixed.at(kind)
  } else if kind == "overview" {
    assert(system != none, message: "System overview requires a system name.")
    [#system: System overview]
  } else if kind == "requirement" or kind == "design" {
    assert(type(index) == int and index > 0 and topic != none,
      message: "Requirement and Design require a positive index and a noun-phrase topic.")
    let prefix = if kind == "requirement" { "Requirement" } else { "Design" }
    [#prefix #index: #topic]
  } else {
    let prefixes = (
      background: "Background", "end-to-end": "End-to-End",
      ablation: "Ablation", evaluation: "Evaluation",
      discussion: "Discussion", appendix: "Appendix",
    )
    assert(kind in prefixes, message: "Unknown academic section kind.")
    assert(topic != none, message: "This section requires a noun-phrase topic.")
    [#(prefixes.at(kind)): #topic]
  }
}

#let section-slide(kind, body, topic: none, index: none, system: none,
  number: auto, title-size: 48, claim: none) = slide(
    section-title(kind, topic: topic, index: index, system: system),
    body, number: number, title-size: title-size, claim: claim)

#let title-slide(title, subtitle, authors, affiliation: [], note: [], number: auto) = canvas[
  #panel(0, 99, 960, 132, fill: style.blue)
  #baseline(60, 151.44, title, size: 36, fill: white)
  #baseline(60, 204, subtitle, size: 36, fill: white)
  #textbox(60, 274.5, 840, authors, size: 20, leading: 9)
  #textbox(60, 352.5, 840, affiliation, size: 20, leading: 9)
  #textbox(60, 440.5, 840, note, size: 20)
  #baseline(894, 522, if number == auto { counter(page).display() } else { number }, size: 12, fill: rgb("777777"))
]

// Standard paper-talk layouts on the shared content grid.
#let evidence-slide(title, source, notes, source-note: [], claim: none,
  title-size: 48, number: auto) = slide(title, title-size: title-size, number: number, claim: claim)[
  #figure(60, 125, 510, 302, source)
  #textbox(592.5, 123, 307.5, notes, size: 20)
  #caption(60, 438, 510, source-note)
]

#let two-column-slide(title, lhs, rhs, split: 0.5, claim: none,
  title-size: 42, number: auto) = {
  let gap = 40
  let width = (840 - gap) * split
  slide(title, title-size: title-size, number: number, claim: claim)[
    #textbox(60, 123, width, lhs)
    #textbox(60 + width + gap, 123, 800 - width, rhs)
  ]
}

#let metric(x, y, w, label, value, detail) = {
  heading(x, y, w, label, size: 20)
  textbox(x, y + 27.75, w, value, size: 22, weight: "bold")
  caption(x, y + 57.75, w, detail)
}

#let results-slide(title, source, metrics, number: auto) = slide(
  title, title-size: 40, number: number)[
  #figure(112.5, 138, 735, 282.67, source)
  #for (i, m) in metrics.enumerate() {
    metric(60 + i * 296.25, 433.5, 270, m.at(0), m.at(1), m.at(2))
  }
]
