# Session 24 Summary

## W3Resource - Function Exercises

### Exercise 1: Maximum of Three Numbers

**Built-in solution**: `max(a, b, c)` - simplest approach

**Manual approaches**:
1. **If-else nested**: Compare pairs using helper function `max_of_two()`
2. **Ternary operators**: `a if a > b and a > c else b if b > c else c`
3. **Recursive**: Shrink list until one element remains, compare along the way
4. **Sorted**: Use `sorted()` to preserve original list (`.sort()` modifies in-place)

**Key insight**: `lst[1:]` creates slice with all elements except first (used in recursion)

### Exercise 2: Sum All Numbers in a List

**Built-in solution**: `sum(lst)` - most efficient

**Manual approaches**:
1. **For-loop accumulation**: Initialize `total = 0`, iterate and `total += i`
2. **Recursion**: `lst[0] + recursive_sum(lst[1:])` base case: empty list returns 0
3. **One-liner recursive**: `piece[0] + getSum(piece[1:]) if piece else 0`
4. **Conditional sum**: `sum(i for i in lst if i > 0)` - filter with comprehension

**Pattern**: `+=` adds value to variable and updates it simultaneously

### Exercise 3: Multiply All Numbers in a List

**Manual approaches**:
1. **For-loop accumulation**: Initialize `total = 1`, iterate and `total *= i`
2. **Recursion**: `piece[0] * getMult(piece[1:])` base case: empty list returns 1
3. **functools.reduce()**: `reduce(lambda x, y: x * y, piece)`
4. **Skip zeros**: Use `continue` in loop or filter with comprehension

**Pattern**: `*=` multiplies value to variable and updates it simultaneously

## functools.reduce()

### Syntax
```python
from functools import reduce
reduce(function, iterable, initial)
```

### Behavior
- **Cumulative application**: Applies function of two arguments from left to right
- **Reduces to single value**: Processes entire iterable into one result
- **Example**: `reduce(lambda x, y: x+y, [1, 2, 3, 4, 5])` → `((((1+2)+3)+4)+5)` → `15`

### Parameters
- **x**: Accumulated value (running total)
- **y**: Current element from iterable
- **initial**: Optional starting value (default when iterable empty)

### Use Cases
- Multiplication: `reduce(lambda x, y: x * y, lst)`
- Finding max: `reduce(lambda x, y: x if x > y else y, lst)`
- Concatenation: `reduce(lambda x, y: x + y, strings)`

## Key Technical Concepts

### List Slicing for Recursion
```python
lst[0]      # First element
lst[1:]     # All except first (the "rest")
```
- **Pattern**: Recursion shrinks list until base case (empty or single element)
- **Base case check**: `if len(lst) == 0` or `if len(lst) == 1` or `if not lst`

### Accumulator Pattern
```python
total = 0           # Sum: start at 0
for i in lst:
    total += i

product = 1         # Product: start at 1
for i in lst:
    product *= i
```
- **Sum initialization**: 0 (identity element for addition)
- **Product initialization**: 1 (identity element for multiplication)

### Ternary Chaining
```python
a if a > b and a > c else b if b > c else c
```
- **Structure**: `value1 if condition1 else value2 if condition2 else value3`
- **Reads left to right**: First true condition returns its value
- **Trade-off**: Concise but can hurt readability with complexity

### sorted() vs .sort()
```python
sorted(nums)        # Returns new sorted list, original unchanged
nums.sort()         # Modifies list in-place, returns None
```
- **sorted()**: Use to preserve original order
- **.sort()**: Use when you want to modify existing list

## Recursive Patterns

### Sum Recursion
```python
def recursive_sum(lst):
    if len(lst) == 0:
        return 0
    return lst[0] + recursive_sum(lst[1:])
```
- **Base case**: Empty list returns 0
- **Recursive case**: First element + sum of rest

### Product Recursion
```python
def getMult(piece):
    return piece[0] * getMult(piece[1:]) if piece else 1
```
- **Base case**: Empty list returns 1
- **Ternary format**: More concise, same logic

### Max Recursion
```python
def recursive_max(lst):
    if len(lst) == 1:
        return lst[0]
    first = lst[0]
    rest_max = recursive_max(lst[1:])
    return first if first > rest_max else rest_max
```
- **Base case**: Single element returns itself
- **Comparison**: First element vs max of rest

## Python Naming Conventions

### Common Variable Names
- **lst**: Represents "list" (avoids overwriting built-in `list` type)
- **piece**: Alternative descriptive name for list parameter
- **nums**: Short for "numbers"
- **total/result**: Accumulator variables

**Why avoid `list`**: Shadows built-in type, can cause issues if you need `list()` constructor

## List Comprehension Filtering

### Conditional Sum
```python
sum(i for i in lst if i > 0)    # Sum only positive
```

### Conditional Product (with reduce)
```python
reduce(lambda x, y: x * y, [i for i in lst if i != 0])
```

**Pattern**: Comprehension filters, then apply operation

## Best Practices

### When to Use Each Approach

| Approach | Best For | Avoid When |
|----------|----------|------------|
| **Built-in** (`sum`, `max`) | Production code | Learning exercise |
| **For-loop** | Readability, debugging | - |
| **Recursion** | Tree structures, learning | Large lists (stack limit) |
| **reduce()** | Functional style, custom operations | When built-in exists |
| **List comprehension** | Filtering + operation | Complex multi-step logic |

### Code Readability
✓ **Clear**: `for i in lst: total += i`  
✓ **Functional**: `reduce(lambda x, y: x * y, lst)`  
⚠ **Dense**: `piece[0] * getMult(piece[1:]) if piece else 1` (requires Python experience)  
✗ **Overcomplicated**: Nested ternary with 4+ conditions