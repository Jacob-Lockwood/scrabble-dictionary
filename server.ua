# Experimental!
H ~ "git: github.com/uiua-lang/webua" ~ ! HtmlResp NotFound Response Serve!

C ← !Class ⍜▽⋅@\s⊸=@\n

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
            Input {
              !name"q"
              !type "text"
              !placeholder"Enter regular expression"
              C $ w-[24ch] outline-none autofill:transition-colors autofill:duration-[5000000ms]
            }
          }
        }
        ∘
      }
    }
  }
)

Index ← HtmlResp Layout H~P "Enter a query to see words."

URLDecode ← ⍜⊜∘≡(+@\0⌝⊥16⇌⊗⊙HexDigits¯↘1)⊸⦷"%\W\W"

°⊟⍉ °⬚@\t csv &fras "./words.tsv"
Words       ←
Definitions ←

WordList ← HtmlResp (
  ▽⊸≡◇(/∨≡⌟◇≍≡⊢⊸regex) ¤⊙Words ⌵URLDecode
  ?↧2⊸⧻
  H!⨬(
    Layout P "No words found"
  | ¯⌵⊢
    Html Head $$ <meta http-equiv="refresh" content="0; url=/words/_" />
  | =0°⊏ ⍜⊙□₃⍚⌞▽± ⟜°⊏ ⊕⊃⧻□⊸≡◇⧻
    Layout Ul⍚(
      Li Details {⊓(
          ⨬(""|"open=1")
        | Summary $"_-letter words (_ found)"
        | Ul⍚(Li A {!href⊸$"/words/_" ¯})
        )}
    )
  )
)

WordDefinition ← HtmlResp Layout /◇⊂H!{⊃(
    H₂
  | P ⬚"not a playable word"⊏⊙Definitions⊗⊙Words□
  | A {⊃(
        C"underline"
      | !href$"https://www.collinsdictionary.com/dictionary/english/_"¯
      | "Read full definition")}
  )}

CSS ← Response "200 OK" "text/css" &frab"./out.css"

Route ← ⍣(
  CSS°"/out.css"
| Index°"/"
| ⍩WordList °$"/words?q=_"
| ⍩WordDefinition ⌵°$"/words/_"
| NotFound
)
Serve!(Route) 8080

# °utf₈ Words "a.*z"

# G! ←^ ⋅""
# G!(
#   "Enter regular expression here"
#   ‼Input(
#     Name="q"
#     Type="text"
#     Class=($"w-[_ch] outline-none"⧻)
#     Placeholder=(∘)
#   )
#   ‼Input(Name "q"|Type "text"|Class $"w-[_ch] outline-none")
# )
