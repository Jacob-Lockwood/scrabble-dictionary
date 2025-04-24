# Experimental!
H ~ "git: github.com/uiua-lang/webua" ~ ! HtmlResp NotFound Response Serve! Tags!

C ← !Class ⍜▽⋅@\s⊸=@\n
Tags!(Code)

# ? href text
ExtA ← H~A {C"underline" !target"_blank" !href ⊙∘}

Layout ← H!(
  Html {
    Head {
      Title "Scrabble Dictionary"
      Script {!src "https://unpkg.com/htmx.org@2.0.4"}
      Link {!href "/out.css" !rel "stylesheet"}
      $ <link rel="preconnect" href="https://fonts.googleapis.com">
      $ <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      $ <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&display=swap" rel="stylesheet">
    }
    Body {
      C"font-serif bg-red-500 min-h-screen"
      Div {
        C"bg-red-50 p-4 my-20 mx-auto max-w-4xl flex flex-col gap-2"
        H₁{
          C"text-red-800 text-4xl font-bold"
          A{!href"/" "Scrabble Dictionary"}
        }
        Form {
          !action"/words" !method"get"
          Div {
            C $ flex font-mono gap-1 border-solid border-2 border-red-300 bg-red-100 p-2 w-full
              $ focus-within:shadow-md shadow-red-400 before:content-['/']
              $ before:text-red-500 after:text-red-500 after:content-['/i']
            !onclick"q.focus()"
            Input {
              !Id⟜!name"q"
              !type "text"
              !placeholder"Enter word or pattern"
              C $ w-[21ch] outline-none autofill:transition-colors autofill:duration-[5000000ms]
              !value∘
            }
          }
        }
        ⊙∘
      }
    }
  }
)

Index ← HtmlResp Layout "" /◇⊂H!{
  Div {C "h-12"}
  H₂ {C"font-bold" ∘} $ About this site
  P {
    $$ This is a dictionary searchable by _
    ExtA "https://www.regexone.com/" "regular expressions."
    $  The words come from the official Collin's Scrabble list.
  }
  P $ Note that queries are case-insensitive; that is, uppercase and lowercase
    $ letters are treated identically.
  # ,P $ Below follows a short reference for searching using regular expressions:
  # Table {
  #   Tr {Th "Pattern" Th "Meaning"}

  #   Tr {Td Code ".*" Td "Any word"}
  #   Tr {Td Code "AB.*" Td "AB- followed by anything"}
  #   Tr {Td Code ".*CD" Td "-CD preceded by anything"}
  # }
}

URLDecode ← ⍜⊜∘≡(+@\0⌝⊥16⇌⊗⊙HexDigits¯↘1)⊸⦷"%\W\W"

°⊟⍉ °⬚@\t csv &fras "./words.tsv"
Words       ←
Definitions ←

WordList ← H!(
  ⌵URLDecode
  HtmlResp Layout⟜(
    ↧2⊸⧻ ⨬(▽⊸≡◇(/∨≡⌟◇≍≡⊢⊸regex)¤⊙Words|□₁) /×⊸±
    ⨬(P "No words found"
    | ¯⊢
      $$ <meta http-equiv="refresh" content="0; url=/words/_" />
    | =0°⊏ ⍜⊙□₃⍚⌞▽± ⟜°⊏ ⊕⊃⧻□⊸≡◇⧻
      Ul⍚(
        Li Details {⊓(
            ⨬(""|"open=1")
          | Summary $"_-letter words (_ found)"
          | Ul⍚(Li A {!href⊸$"/words/_" ¯})
          )}
      )
    ))
)

WordDefinition ← HtmlResp Layout ⊃⌵(
  /◇⊂H!{
    ⊃(H₂
    | P ⬚"not a playable word"⊏⊙Definitions⊗⊙Words□
    | ExtA⊃(
        $"https://www.collinsdictionary.com/dictionary/english/_"
      | "Read full definition"
      )¯
    | ExtA⊃(
        $"https://www.google.com/search?q=_&udm=2"
      | $"View google images of _"
      )¯
    )}
)

CSS     ← Response "200 OK" "text/css" &frab"./out.css"
Favicon ← Response "200 OK" "image/x-icon" &frab"./favicon.ico"

Route ← ⍣(
  CSS°"/out.css"
| Favicon°"/favicon.ico"
| Index°"/"
| ⍩WordList °$"/words?q=_"
| ⍩WordDefinition ⌵°$"/words/_"
| NotFound
)
Serve!(Route) 8080
