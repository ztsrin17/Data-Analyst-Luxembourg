# Session 22 Summary

## W3Schools - Variable Fundamentals

### Multiple Assignment Patterns
```python
x, y, z = "Orange", "Banana", "Cherry"  # Multiple values
x = y = z = "Orange"                     # Same value
x, y, z = fruits                         # Unpacking from list
```

### Variable Scope
- **Local variables**: Defined inside function, only accessible within function
- **Global variables**: Defined outside functions, accessible everywhere
- **global keyword**: Modify global variable from within function
```python
def myfunc():
    global x
    x = "fantastic"  # Changes global x
```

## PyNative - Basic Exercises

### Exercise 1: Conditional Return
Product if ≤1000, otherwise sum - straightforward conditional logic implementation

### Exercise 2: Current + Previous Number Sum
- **Custom range**: Used `range(1, numberend + 1)` to include endpoint
- **Pattern**: Print current number, previous number, and their sum
- **Edge case**: Handled number 0 separately

### Exercise 3: Even/Odd Index Characters
- **Key insight**: `range(start, stop, step)` with step=2 for every other element
- **Even indices**: `range(0, len(str), 2)` → 0, 2, 4, 6...
- **Odd indices**: `range(1, len(str), 2)` → 1, 3, 5, 7...
- **Access character**: Use `str[index]`, not `str(index)`
- **No +1 needed**: `len(str)` already goes up to but not including length

## PyNative - Functions Exercises

### Exercise 1: String Formatting Review
Comparison of concatenation vs f-strings for name/age output

### Exercise 2: *args (Variable Arguments)
- **Definition**: `*args` collects arbitrary number of positional arguments into tuple
- **Usage**: Function can accept any number of parameters
- **Unpacking**: `func1(*list)` unpacks list elements as separate arguments
```python
def func1(*args):
    for value in args:
        print(value, end=" ")
```

### Exercise 3: Multiple Return Values
- **Tuple unpacking**: Functions can return multiple values separated by commas
```python
def calculation(a, b):
    return a + b, a - b  # Returns tuple (sum, difference)
```

## Key Technical Concepts

### String Indexing
- **Zero-based**: First character is index 0
- **Last valid index**: `len(string) - 1`
- **Access syntax**: Square brackets `string[i]`, not parentheses

### range() Step Parameter
```python
range(start, stop, step)
range(0, 10, 2)   # 0, 2, 4, 6, 8
range(1, 10, 2)   # 1, 3, 5, 7, 9
```

### Function Return Patterns
- **Single value**: `return value`
- **Multiple values**: `return value1, value2` (returns tuple)
- **No return**: Function returns `None` by default

## Python Terminology

### *args (Arbitrary Arguments)
- **Syntax**: Asterisk before parameter name
- **Behavior**: Packs multiple positional arguments into tuple
- **Use case**: When function needs flexible number of inputs
- **Example**: `def func(*args):` accepts any number of arguments

### **kwargs (Keyword Arguments)
- **Syntax**: Double asterisk before parameter name
- **Behavior**: Packs keyword arguments into dictionary
- **Access**: Loop through `.items()` for key-value pairs
```python
def func(**kwargs):
    for key, value in kwargs.items():
        print(key, value)
```

### Unpacking
- **List unpacking**: `x, y, z = [1, 2, 3]`
- **Function argument unpacking**: `func(*list)` passes list elements as separate args
- **Must match**: Number of variables must equal number of values

## Common Patterns Discovered

### User Input Loop
```python
user_values = []
for i in range(count):
    value = input("")
    user_values.append(value)
```

### Tuple Return with Assignment
```python
sum_result, diff_result = calculation(a, b)
```

## Debugging Lessons

### Syntax Mistakes
- **Wrong**: `string(index)` - parentheses for function calls
- **Correct**: `string[index]` - square brackets for indexing
- **Case sensitivity**: Python keywords are lowercase (`global`, not `Global`)

### Range Understanding
- **Stop parameter**: Always excluded from result
- **No need for +1**: When iterating through string length, `len(str)` is already correct endpoint