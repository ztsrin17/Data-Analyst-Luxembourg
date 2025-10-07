# Python Cheat Sheet

## Basic Operations

### Print & Type Checking
```python
print("Hello")                    # Output text
print(value1, value2, sep=' ')    # Multiple values with separator
print(value, end='\n')            # Control line ending
type(variable)                     # Check data type
```

### Arithmetic Operators
| Operator | Name | Example | Result |
|----------|------|---------|--------|
| `+` | Addition | `5 + 3` | `8` |
| `-` | Subtraction | `5 - 3` | `2` |
| `*` | Multiplication | `5 * 3` | `15` |
| `/` | True division | `5 / 2` | `2.5` |
| `//` | Floor division | `5 // 2` | `2` (rounds down) |
| `%` | Modulus | `5 % 2` | `1` (remainder) |
| `**` | Exponentiation | `5 ** 2` | `25` |
| `-a` | Negation | `-5` | `-5` |

**Built-in Math Functions**: `min()`, `max()`, `abs()`

### Type Conversion
```python
float(10)           # 10.0
int(3.33)           # 3 (truncates decimals)
int('807')          # 807 (string to integer)
```

## Variables

### Assignment & Calculations
```python
color = "blue"
pi = 3.14159
radius = diameter / 2
area = pi * (radius ** 2)
```

### Variable Swapping (Using Temporary Variable)
```python
c = a   # Store original value of a
a = b   # Assign b's value to a
b = c   # Assign original a value to b
```

### Pythonic Swapping (Tuple Unpacking)
```python
# Swap two variables without temporary variable
a, b = b, a

# Swap list elements
racers[0], racers[-1] = racers[-1], racers[0]
```

## Data Types

### Core Types
- **int**: Whole numbers (`42`, `-10`)
- **float**: Decimal numbers (`3.14`, `-0.5`)
- **bool**: True/False values
- **str**: Text in quotes (`"hello"`, `'world'`)

### Truthy and Falsy Values
**Falsy values** (evaluate to False):
- `0`, `0.0`
- `False`
- `None`
- Empty sequences: `""`, `[]`, `()`

**Truthy values**: Everything else (non-zero numbers, non-empty strings/lists)

```python
bool(1)      # True (all numbers except 0)
bool(0)      # False
bool("text") # True (all strings except empty)
bool("")     # False
```

## Functions

### Basic Function Syntax
```python
def function_name(parameter1, parameter2):
    """Docstring explaining what function does
    
    >>> function_name(1, 2)
    3
    """
    result = parameter1 + parameter2
    return result
```

### Function Features
```python
# Default parameter values
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

# Functions as arguments
def call(fn, arg):
    return fn(arg)

# Key parameter for built-in functions
max(100, 51, 14, key=lambda x: x % 5)  # Find max based on modulo 5
```

### Getting Help
```python
help(function_name)  # Display function documentation
help(print)          # See parameters: sep, end, file, flush
```

## Comparison Operators

| Operator | Description |
|----------|-------------|
| `==` | Equal to |
| `!=` | Not equal to |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less than or equal to |
| `>=` | Greater than or equal to |

```python
def is_odd(n):
    return (n % 2) == 1
```

### Direct Boolean Returns
**Pattern**: Comparison operators already return boolean values—no need for explicit if/else

```python
# Verbose (unnecessary)
def is_negative(number):
    if number < 0:
        return True
    else:
        return False

# Concise (preferred)
def is_negative(number):
    return number < 0
```

## Boolean Logic

### Logical Operators
- `and`: Both conditions must be True
- `or`: At least one condition must be True
- `not`: Negates the condition

```python
def can_run_for_president(age, is_natural_born_citizen):
    return is_natural_born_citizen and (age >= 35)

# Chaining comparisons (Python-specific)
1 < x < 10  # Equivalent to: (1 < x) and (x < 10)
```

### Operator Precedence
**Order of evaluation**: `not` → `and` → `or`

```python
True or True and False  # True (and evaluated first)
# Equivalent to: True or (True and False)

# Use parentheses for clarity
(True or True) and False  # False
```

**Important**: `or` returns first truthy value, not necessarily boolean
```python
1 or 0      # Returns 1 (not True)
0 or 2      # Returns 2 (first truthy value)
```

### Best Practice Example
```python
# Use parentheses for complex conditions
prepared_for_weather = (
    have_umbrella 
    or ((rain_level < 5) and have_hood) 
    or (not (rain_level > 0 and is_workday))
)
```

### Conditional Expressions (Ternary Operator)
```python
# Standard if/else
if total_candies == 1:
    message = "Splitting 1 candy"
else:
    message = "Splitting " + str(total_candies) + " candies"

# Ternary expression (concise)
message = "Splitting 1 candy" if total_candies == 1 else f"Splitting {total_candies} candies"

# General syntax
value = value_if_true if condition else value_if_false
```

## Conditional Statements

### If-Elif-Else Structure
```python
if condition1:
    # Code block executed if condition1 is True
    print("Condition 1 met")
elif condition2:
    # Code block executed if condition2 is True
    print("Condition 2 met")
else:
    # Code block executed if all conditions are False
    print("No conditions met")
```

### Indentation is Critical
**Python uses indentation to define code blocks** (not curly braces like other languages)

```python
def f(x):
    if x > 0:
        print("Only when positive")      # Indented = inside if
        print("Also only when positive") # Same indentation level
    print("Always printed")              # Outdented = outside if
```

## Lists

### Creating and Accessing Lists
```python
# Create list
numbers = [1, 2, 3, 4, 5]
mixed = [1, "text", True, 3.14]  # Can contain mixed types

# Indexing (zero-based)
numbers[0]      # 1 (first element)
numbers[-1]     # 5 (last element)
numbers[1:3]    # [2, 3] (slicing, end index excluded)

# Length
len(numbers)    # 5
```

### List Methods
```python
# Modifying lists
numbers.append(6)        # Add to end: [1, 2, 3, 4, 5, 6]
numbers.pop()            # Remove and return last: [1, 2, 3, 4, 5]
numbers.sort()           # Sort in place: [1, 2, 3, 4, 5]
numbers.reverse()        # Reverse in place: [5, 4, 3, 2, 1]

# Querying lists
numbers.count(3)         # Count occurrences of 3
numbers.index(3)         # Find index of first 3
```

**Important**: Methods like `.reverse()` modify in-place and return `None` (can't chain operations)

### List Operations
```python
# Concatenation
[1, 2] + [3, 4]         # [1, 2, 3, 4]

# Repetition
[1, 2] * 3              # [1, 2, 1, 2, 1, 2]

# Reversing (three methods)
numbers.reverse()       # In-place: modifies original, returns None
numbers[::-1]           # Slicing: creates new reversed list
list(reversed(numbers)) # Function: creates new reversed list
```

### Mutable vs Immutable
- **Lists are mutable**: Can be modified after creation
- **Strings are immutable**: Cannot be changed, only replaced

```python
my_list = [1, 2, 3]
my_list[0] = 99         # Works: [99, 2, 3]

my_string = "hello"
my_string[0] = "H"      # ERROR: strings are immutable
```

### Nested Lists and Length
```python
a = [1, 2, 3]           # len(a) == 3
b = [1, [2, 3]]         # len(b) == 2 (nested list counts as single element)
c = []                  # len(c) == 0 (empty list, not None)
d = [1, 2, 3][1:]       # len(d) == 2 (slice creates new list)
```
**Key Point**: `len()` counts top-level elements only; nested structures count as one element

### Index-Based Logic
```python
# Find position and use for calculations
def fashionably_late(arrivals, name):
    order = arrivals.index(name)
    return order >= len(arrivals) / 2 and order != len(arrivals) - 1
```

## Python vs SQL vs Excel

| Feature | Python | SQL | Excel |
|---------|--------|-----|-------|
| **Data Storage** | Variables in memory | Database tables | Worksheet cells |
| **Conditionals** | if-elif-else | CASE WHEN | IF/IFS functions |
| **Reusability** | Functions | Views/CTEs | Named ranges |
| **Indexing** | Zero-based `[0]` | One-based | One-based (A1) |
| **Dynamic Sizing** | Yes (lists grow) | Fixed tables | Manual resize |

## Tips & Best Practices

### Code Organization
- **DRY Principle**: Don't Repeat Yourself - use functions instead of copying code
- **Docstrings**: Document function purpose and usage with triple quotes
- **Meaningful names**: Use descriptive variable/function names

### Common Patterns
- **Modulo for remainders**: `total_candies % friends` (distributing items evenly)
- **Boolean returns**: Functions can return comparison results directly
- **Short-circuit evaluation**: `and`/`or` stop once result is determined
- **Boolean arithmetic**: Use `sum([bool1, bool2, bool3])` to count True conditions

### Practical Examples
```python
# Hot dog topping logic patterns
all_three = ketchup and mustard and onion
no_toppings = not (ketchup or mustard or onion)
exactly_one = sum([ketchup, mustard, onion]) == 1

# Multi-condition decision (game strategy example)
def should_hit(player_total, soft_hand, dealer_total):
    return (
        player_total <= 11 or                            # Always safe
        (soft_hand and player_total <= 17) or            # Soft hand flexibility
        (not soft_hand and 12 <= player_total <= 16 and dealer_total >= 7)
    )
```

### Common Pitfalls
- **Indentation errors**: Inconsistent spacing breaks code structure
- **Integer division**: Use `//` for floor division, `/` returns float
- **Truthy/Falsy confusion**: Empty containers and 0 are falsy
- **List mutability**: Changes affect original list, be careful with modifications
- **Operator precedence**: Use parentheses to clarify complex boolean expressions
- **In-place methods return None**: `list.reverse()` returns `None`, not the reversed list
- **Empty list length**: `len([])` is `0`, not `None`
- **Nested list counting**: `len([1, [2, 3]])` is `2`, nested lists count as one element