# Valid Parentheses Checker (x86-64 Assembly)

This is a small project written in **x86-64 assembly** (AT&T syntax).  
It checks whether a string of brackets is properly balanced and nested. If the string is correct, the program returns `"valid"`, otherwise `"invalid"`.

---

## 📂 Files

- **`check_validity.s`**  
  Implements the `check_validity` subroutine and a small `main` wrapper.
- **`basic.s`**, **`basicInvalid.s`**, **`neighboringValid.s`**  
  Contain example input strings (labeled `MESSAGE`).  
  You can include one of them in `check_validity.s` with:
  ```asm
  .include "basic.s"
  ```
  Change the filename to test different cases.

---

## ⚙️ Building

This project depends on `gcc` for assembling and linking against libc.  
Use `-no-pie` to avoid PIE issues.

Example build:

```bash
# using basic.s as input
gcc -no-pie check_validity.s basic.s -o validparen
```

To test other examples:

```bash
# with an invalid input
gcc -no-pie check_validity.s basicInvalid.s -o validparen
./validparen

# with neighboring valid input
gcc -no-pie check_validity.s neighboringValid.s -o validparen
./validparen
```



## ▶️ Usage

Run the program after building:

```bash
./validparen
```

The output will be either:

```
valid
```

or

```
invalid
```

depending on the included test file.

---

## 🧠 How It Works

- The program scans the input string character by character.
- On an opening bracket (`<`, `[`, `{`, `(`), it pushes it onto the stack.
- On a closing bracket (`>`, `]`, `}`, `)`), it checks the top of the stack:
  - If it matches the correct opening bracket → continue.
  - If it doesn’t match → return `"invalid"`.
- At the end:
  - If all brackets were matched → `"valid"`.
  - Otherwise → `"invalid"`.

---

## ✅ Examples

- Input: `<[()]>` → `valid`
- Input: `(<)>`   → `invalid`
- Input: `({[]})` → `valid`

---
