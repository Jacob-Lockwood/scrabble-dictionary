# Experimental!
H ~ "git: github.com/uiua-lang/webua" ~ ! HtmlResp NotFound Response Serve!

C ← !Class ⍜▽⋅@\s⊸=@\n
Index ← HtmlResp H!(
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
        H₁{C"text-red-800 text-4xl font-bold" "Scrabble Dictionary"}
        Form {
          HXGet "/words" HXSwap "innerHTML" HXTarget "#display"
          Div {
            C $ flex font-mono gap-1 border-solid border-2 border-red-300 bg-red-100 p-2 w-full
              $ focus-within:shadow-md shadow-red-400 before:content-['/^']
              $ before:text-red-500 after:text-red-500 after:content-['$/i']
            Input {!name"q" !type "text" C$"w-[_ch] outline-none autofill:transition-colors autofill:duration-[5000000ms]" ⧻⟜!placeholder "Enter regular expression"}
            Button {!type "submit" ""}
          }
        }
        Div {
          !Id "display"
          P "Enter a query to see words"
        }
      }
    }
  }
)

CSS ← Response "200 OK" "text/css" &frab"./out.css"

URLDecode ← ⍜⊜∘≡(+@\0⌝⊥16⇌⊗⊙HexDigits¯↘1)⊸⦷"%\W\W"

°⊟⍉ °⬚@\t csv &fras "./words.tsv"
Words       ←
Definitions ←

WordList ← (
  ▽⊸≡◇(⧻regex) ¤⊙Words $"^_$"⌵URLDecode
  =0°⊏ ⍜⊙□₃⍚⌞▽± ⟜°⊏ ⊕⊃⧻□⊸≡◇⧻
  # ∩⌞▽±⊸≡◇⧻ °˜⊏⊕□⊸≡◇⧻
  HtmlResp H!(
    Ul⍚(
      Li Details {⨬""(!open"true") ⊙⊓(Summary $"_-letter words (_ found)"|Ul⍚Li)}
    )
  )
)

Route ← ⍣(
  Index°"/"
| CSS°"/out.css"
| ⍩WordList °$"/words?q=_"
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
