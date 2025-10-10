# Session 21 Summary

## Invent with Python - Exercises 4 & 5

### Exercise 4: Area & Volume Calculator
- **Multiple function definitions**: Created `area()`, `perimeter()`, `volume()`, `surfaceArea()` functions
- **Float input conversion**: Used `float(input())` for decimal precision
- **Rounding output**: Applied `round(value, 2)` in f-strings for clean display
- **Assert testing**: All test cases passed on first attempt
- **Success factor**: Applied patterns from previous exercises (ex2 & ex3)

### Exercise 5: FizzBuzz Challenge
- **Initial approach**: Single number divisibility checker (successful first try)
- **Key learning**: Python requires lowercase `and`, `or`, `not` (not `AND`, `OR` like SQL/Excel)
- **Case sensitivity**: Important distinction coming from SQL background
- **Range iteration**: Discovered `range(1, upTo + 1)` includes endpoint
- **Print control**: Used `end=' '` parameter to prevent newlines

## Key Technical Concepts

### range() Function
```python
range(10)           # 0-9 (excludes endpoint)
range(1, 11)        # 1-10 (includes start, excludes end)
range(150, 202, 2)  # 150-200 by 2s (step parameter)
list(range(1, 11))  # Convert to list: [1, 2, 3, ..., 10]
```

### String Methods
- **rjust()**: Right-justify string with padding
  - Syntax: `string.rjust(length, fill_char)`
  - Default padding: space character
  - Used for aligned output formatting

### Print Parameters (help(print))
```python
print(*args, sep=' ', end='\n', file=None, flush=False)
```
- **sep**: Separator between values (default: space)
- **end**: String after last value (default: newline)
- **Usage**: `print(value, end=' ')` for horizontal output

## FizzBuzz Implementation Patterns

### Pattern 1: Function with Internal Loop
```python
def fizzBuzz(upTo):
    for number in range(1, upTo + 1):
        if number % 3 == 0 and number % 5 == 0:
            print("FizzBuzz", end=' ')
        elif number % 3 == 0:
            print("Fizz", end=' ')
        elif number % 5 == 0:
            print("Buzz", end=' ')
        else:
            print(number, end=' ')
```

### Pattern 2: List Comprehension with join()
```python
def fizzbuzz(n):
    if n % 3 == 0 and n % 5 == 0:
        return "FizzBuzz"
    elif n % 3 == 0:
        return "Fizz"
    elif n % 5 == 0:
        return "Buzz"
    else:
        return str(n)

results = [fizzbuzz(n) for n in range(1, upTo + 1)]
print(" ".join(results))
```

## Problem-Solving Progression

### Initial Misunderstanding
- Attempted to print entire list: `print(list(range(1, upTo + 1)))`
- Realized need for individual element processing with conditional logic

### Breakthrough Concepts
1. **Loop integration**: Combine `for` loop with function calls
2. **Range endpoint**: `range(1, upTo + 1)` to include final number
3. **Print control**: Modify `end` parameter for horizontal output
4. **join() method**: Combine list elements into single string with separator

## Python vs SQL/Excel - Case Sensitivity

| Language | Logical Operators | Case Sensitivity |
|----------|------------------|------------------|
| Python | `and` `or` `not` | Lowercase required |
| SQL | `AND` `OR` `NOT` | Uppercase convention |
| Excel | `AND()` `OR()` `NOT()` | Function format |

**Key Takeaway**: Python's strict lowercase requirement for logical operators is easy to forget when transitioning from SQL/Excel

## Learning Strategy Insights

### Effective Patterns
- **Build incrementally**: Start with simple version, add complexity
- **Test immediately**: Use assert statements to verify correctness
- **Use help() function**: Query built-in documentation for parameters
- **Interactive shell testing**: Experiment with syntax before implementing