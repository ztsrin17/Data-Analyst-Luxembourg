# Python Quick Reference

## Operators

| Arithmetic | Comparison | Logical |
|------------|------------|---------|
| `+` `-` `*` `/` | `==` `!=` | `and` `or` `not` |
| `//` (floor div) | `<` `>` | `1 < x < 10` (chaining) |
| `%` (modulo) | `<=` `>=` | |
| `**` (power) | | |

## Data Types

| Type | Example | Check |
|------|---------|-------|
| int | `42` | `type(x)` |
| float | `3.14` | `isinstance(x, int)` |
| bool | `True` `False` | |
| str | `"text"` `'text'` | |
| list | `[1, 2, 3]` | |

**Falsy values:** `0`, `False`, `None`, `""`, `[]`, `()`

## Common Functions

```python
print(x, y, sep=' ', end='\n')    # sep: separator, end: line ending
len(list)  min(x, y)  max(x, y)  abs(x)
round(x, 2)  sum(list)  any(list)  all(list)
type(x)  help(func)
int(x)  float(x)  str(x)  bool(x)
range(5)         # 0-4
range(1, 11)     # 1-10 (excludes end)
range(0, 10, 2)  # 0,2,4,6,8 (step by 2)

# Higher-order functions with lambda
list(filter(lambda x: x % 2 == 0, nums))   # Keep only even
list(map(lambda x: x * 2, nums))           # Double each element
sorted(data, key=lambda x: x[1])           # Sort by 2nd element
```

## Strings

```python
f"{var} text {expr}"              # f-string (preferred)
"text" + str(num)                 # concatenation
" ".join(list)                    # join list elements with separator
s.upper()  s.lower()  s.strip()
s.replace(old, new)  s.split()
s.rjust(width, char)              # right-justify with padding
s[0]  s[-1]  s[1:3]              # indexing/slicing
```

## Lists

```python
# Create/Access
list = [1, 2, 3]
list[0]  list[-1]  list[1:3]

# Methods (modify in-place, return None)
list.append(x)  list.pop()  list.reverse()  list.sort()
list.count(x)  list.index(x)

# Operations (return new list)
list1 + list2  list * 3  list[::-1]  list(reversed(list))
```

## Control Flow

```python
# If-elif-else
if condition:
    code
elif condition:
    code
else:
    code

# Ternary
value = true_val if condition else false_val
```

## Loops

```python
# For loop
for item in iterable:
    code
    break      # exit loop
    continue   # skip to next

# Range
for i in range(5):        # 0-4
for i in range(1, 10):    # 1-9 (excludes end)
for i in range(0, 10, 2): # 0,2,4,6,8 (step by 2)
for i in range(1, 10, 2): # 1,3,5,7,9 (odd numbers)
list(range(1, 11))        # [1, 2, 3, ..., 10]

# Loop through string indices
for i in range(len(string)):
    print(string[i])

# While
while condition:
    code
    i += 1
```

## List Comprehensions

```python
[expr for item in iterable]                    # transform
[expr for item in iterable if condition]       # filter
{expr for item in iterable}                    # set
{key: val for item in iterable}                # dict
(expr for item in iterable)                    # generator
```

## Functions

```python
def func_name(param1, param2=default):
    """Docstring"""
    return value

# Multiple returns (returns tuple)
def calc(a, b):
    return a + b, a - b
sum_val, diff_val = calc(5, 3)

# Variable arguments
def func(*args):               # Accepts any number of positional args (tuple)
    for val in args:
        print(val)
func(1, 2, 3)

def func(**kwargs):            # Accepts keyword arguments (dict)
    for key, val in kwargs.items():
        print(key, val)
func(a=1, b=2)

# Inner functions (closures)
def outer(a, b):
    def inner():
        return a + b           # Accesses outer variables
    return inner()

# Recursive function
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

# Function assignment
show = display                 # Assign function to new name
show()                         # Call through new name

# Lambda (anonymous function)
square = lambda x: x ** 2
sorted(data, key=lambda x: x[1])  # Sort by second element
```

## Input/Output

```python
name = input("Prompt: ")         # returns string
num = int(input("Number: "))     # convert to int
num = float(input("Decimal: "))  # convert to float
```

## Common Patterns

```python
# Swap
a, b = b, a

# Unpack and call function
values = [1, 2, 3]
func(*values)              # Unpacks as func(1, 2, 3)

# Multiple returns
sum_val, diff_val = calc(a, b)

# Print without newline
print(x, end=' ')

# Join list into string
" ".join([str(x) for x in list])

# Check type
if isinstance(x, int):

# Loop with index
for i in range(len(list)):
    list[i]

# Every other element (even indices)
for i in range(0, len(string), 2):
    print(string[i])

# Every other element (odd indices)
for i in range(1, len(string), 2):
    print(string[i])

# Adjacent elements
for i in range(len(list) - 1):
    list[i], list[i+1]

# Unused variable
for _ in range(n):

# Count True values
sum([x > 0 for x in list])

# Check any/all
any(x > 0 for x in list)
all(x > 0 for x in list)

# FizzBuzz pattern
for n in range(1, upTo + 1):
    if n % 3 == 0 and n % 5 == 0:
        print("FizzBuzz", end=' ')
    elif n % 3 == 0:
        print("Fizz", end=' ')
    elif n % 5 == 0:
        print("Buzz", end=' ')
    else:
        print(n, end=' ')
```

## Indexing

```python
list[0]      # first
list[-1]     # last
list[1:4]    # slice [1,2,3] (end excluded)
list[:3]     # first 3
list[3:]     # from index 3 to end
list[::-1]   # reverse
list[::2]    # every 2nd element (0,2,4,...)
list[1::2]   # every 2nd starting at 1 (1,3,5,...)
```

## Key Differences from SQL/Excel

- **Zero-based indexing** (first element is `[0]`)
- **Indentation matters** (defines code blocks)
- **Variables store in memory** (not cells)
- **Lists are mutable** (can change after creation)
- **Methods can modify in-place** (often return `None`)

## Quick Syntax Rules

✓ **Pythonic:** `f"{x}"` `a, b = b, a` `[x for x in list]` `lambda x: x * 2`  
✗ **Avoid:** `str(x) + ", " + str(y)` (use f-strings) | Complex lambdas (use `def`)  
✓ **Direct return:** `return x > 0` (not `if x > 0: return True`)  
✓ **Error handling:** `raise ValueError("msg")` (not `return print()`)  
⚠ **Remember:** `input()` returns string, convert with `int()` or `float()`  
⚠ **Case sensitive:** `and` `or` `not` (lowercase only, not `AND` `OR` `NOT`)  
⚠ **Range excludes end:** `range(1, 11)` gives 1-10, not 1-11  
⚠ **Indexing syntax:** `string[i]` not `string(i)` (square brackets, not parentheses)  
⚠ **Scope:** Local variables don't affect global unless using `global` keyword  
⚠ **Recursion limit:** Python has max recursion depth; prefer iteration for large values