---
name: jkmdfmt
description: Format up an LLM answer into consistent personal markdown style — sentence-case headings and bullet lead-ins, plain dash bullets, no emoji, straight em-dash handling, italics not bold, optional 100-col wrap. Pass a file path to clean in place, or paste raw text to get the cleaned result back in chat.
---

**Input:** if the arg is an existing file path, read it and overwrite it in place with the cleaned
result — no confirmation, no backup. Otherwise treat the arg (or whatever text follows) as raw
pasted content and print the cleaned markdown back in the chat response, in a fenced code block.

**Formatting only — never change meaning.** Don't cut, summarize, or reorder content, and don't
"improve" the argument or claims. Every transformation below is style/casing/punctuation only.
Leave code blocks, inline code spans, URLs, and citation markers (e.g. `[1]`) byte-for-byte
untouched.

## Rules

1. **Sentence-case headings.** `## Title Of Sections Goes Here` → `## Title of sections goes here`.
   Capitalize only the first word of the heading; lowercase the rest — including any text after a
   colon (`Part 1: Strategic Pros` → `Part 1: strategic pros`, not `Part 1: Strategic pros`). Keep
   proper nouns, product/company names, and acronyms capitalized as they normally would be
   (Microsoft, IBM, John Doe) — this is a case *change*, not a blanket lowercase, so anything that's
   correctly uppercase in normal prose stays uppercase. E.g. `## Storms In Africa` → `## Storms in
   Africa` (lowercase "in", but "Africa" stays capitalized because it's a proper noun, not because
   it was title-cased). When in doubt whether a word is a proper noun, leave its casing alone.

2. **Sentence-case bullet lead-ins.** The same rule applies to a title-cased phrase leading a bullet,
   typically ending in a colon: `* Regarding Project Requirements: Ask
   that...` → `- Regarding project requirements: Ask that...`. First word
   capitalized, rest lowercased except proper nouns/acronyms (same "don't touch real uppercase"
   caveat as rule 1). Don't touch casing elsewhere in normal prose sentences — only title-cased
   labels/headings get this treatment.

3. **Strip emoji from headings and bullet lead-ins**, e.g. `## 📋 Part 2: ...` → `## Part 2: ...`.
   Remove the emoji and any leftover leading space; don't hunt for emoji elsewhere in prose unless
   asked.

4. **Remove `---` horizontal-rule dividers** between sections. Delete the line; normalize
   surrounding blank lines to a single blank line.

5. **Bold → italics for mid-sentence emphasis.** `**this is important**` inside a sentence becomes
   `_this is important_`. Same with `- **Note:** ...` → `- _Note:_`.

6. **Bullet leader `*` → `-`** for unordered lists, at every nesting level.

7. **Em dashes.** Replace ` — ` (em dash with surrounding spaces) per sentence:
   - If the sentence has exactly one em dash introducing a trailing explanation/clause, prefer
     rewriting it as a colon: `This is good — it shows.` → `This is good: it shows.`
   - Otherwise (two or more em dashes, e.g. a parenthetical aside, or a colon reads awkwardly),
     replace each em dash with a bare triple-hyphen and no surrounding spaces: `This is good — and it
     shows — keep doing that.` → `This is good---and it shows---keep doing that.`

8. **Blank line after every heading**, and single blank lines (never more) between paragraphs and
   before/after list blocks. Collapse doubled/tripled blank lines.

9. **Reflow to ~100-column line wrap** where practical. Bonus, not required — skip if it would be
    risky (e.g. inside anything that looks like it should stay verbatim).

10. **If the pasted content includes the user's own question/prompt** (not just the LLM's answer),
    fix its sentence-start and `I` casing only (`i'm here to ask for this. and that.` →
    `I'm here to ask for this. And that.`). Don't apply the heading/bullet title-case rules to it —
    those are for the LLM's structured answer.

## What not to do

- Don't drop or trim sections, even ones that look tangential or redundant — that's a content
  decision, not formatting, and is out of scope for this skill.
- Don't rewrite phrasing, fix claims, or add/remove content of any kind.
- Don't touch footnote/reference lists at the bottom — leave them as-is even if a renumbering would
  seem tidier.
