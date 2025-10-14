# Session 23 Summary

## SQL Refresh

**PostgreSQL Exercises** - Completed all basic exercises on pgexercises.com for skill maintenance

## Python Functions - Advanced Concepts

### Inner Functions (Closures)
- **Closure**: Inner function "remembers" variables from outer function's scope
- **No parameter shadowing needed**: Inner function can access outer function's parameters directly
```python
def outer_fun(a, b):
    def inner_fun():
        return a + b  # Accesses outer a, b
    return inner_fun() + 5
```

### Default Arguments
- **Best practice**: Set default value in function definition, not with None checks
```python
def show_employee(name, salary=9000):  # Pythonic
    print("Name:", name, "salary:", salary)
```

### Recursive Functions
- **Use case**: Learning tool, tree traversal, factorial, Fibonacci
- **Performance**: Slower than built-in iterative solutions, uses call stack memory
- **Risk**: Can hit recursion limit for large values
- **Practical**: Use `sum(range(...))` for production; use recursion when problem naturally fits pattern

**Recursion limit**: Python has maximum recursion depth to prevent stack overflow

### Function Assignment
- **Functions are objects**: Can be assigned to variables and called by new name
```python
show_student = display_student
show_student("Jason", 54)  # Works identically
```

### Positional vs Keyword Arguments
- **Positional**: Values passed in same order as parameters
- **Keyword**: Values passed with parameter name, any order
```python
describe_pet("Laboon", "Rwrw")              # Positional
describe_pet(pet_name="Rwrw", animal_type="Laboon")  # Keyword
```

### **kwargs (Keyword Arguments)
- **Packs into dictionary**: All keyword arguments become key-value pairs
- **Iterate with .items()**: Loop through argument names and values
```python
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=30, city="New York")
```

### Global Variable Modification
- **global keyword**: Required to modify global variable inside function
- **Without global**: Creates new local variable instead of modifying global
```python
global_var = 10
def modify_gv():
    global global_var
    global_var = 15  # Modifies the global variable
```

### Error Handling Best Practice
- **raise ValueError**: Better than `return print()` for invalid inputs
- **None return issue**: `return print()` returns `None`, not the printed message
```python
if num < 0:
    raise ValueError(f"Factorial not defined for {num}")
```

## Lambda Functions

### Syntax
```python
lambda arguments : expression
```
- **Single expression only**: Cannot contain statements or multiple lines
- **Anonymous**: No function name needed
- **Use case**: Short-term tasks, avoiding full `def` when overkill

### Lambda with Built-in Functions

#### filter()
- **Purpose**: Creates list of items where function returns True
- **Returns**: Filter object (convert to list)
```python
even_numbers = list(filter(lambda i: i % 2 == 0, numbers))
```

#### map()
- **Purpose**: Applies function to every item in iterable
- **Returns**: Map object (convert to list)
```python
doubled = list(map(lambda i: i * 2, numbers))
```

#### sorted()
- **key parameter**: Function to extract comparison key from each element
- **Use case**: Sort by specific element in tuple/list
```python
sorted(data, key=lambda i: i[1])  # Sort by second element
```

### Higher-Order Functions
- **Definition**: Functions that accept other functions as arguments
- **Example**: `apply_operation(func, x, y)` takes function and applies it
- **Flexibility**: Can pass regular functions or lambda functions

## Key Technical Insights

### Recursion vs Iteration

| Feature | Recursive | Iterative (sum/range) |
|---------|-----------|----------------------|
| **Clarity** | Shows how recursion works | Instantly readable |
| **Performance** | Slower (many function calls) | Very fast (C implementation) |
| **Memory** | Uses call stack | Constant memory |
| **Pythonic** | Educational | Preferred for production |
| **Risk** | Recursion limit | None |

### Lambda Advantages
- **Concise**: One-line function definition
- **Inline**: Used directly where needed (no separate `def` required)
- **Temporary**: Perfect for throwaway logic with map/filter/sorted

### Lambda Limitations
- **Single expression**: Cannot use multiple statements or lines
- **Readability**: Complex lambdas harder to debug than named functions
- **No docstrings**: Cannot document like regular functions

## Function Concepts Comparison

### Python vs SQL vs Excel

| Concept | Python | SQL | Excel |
|---------|--------|-----|-------|
| **Default values** | `def func(x=5):` | `COALESCE(x, 5)` | `IF(ISBLANK(A1), 5, A1)` |
| **Filter** | `filter(func, list)` | `WHERE` clause | `FILTER()` function |
| **Map/Transform** | `map(func, list)` | `SELECT expression` | Formula drag-down |
| **Recursion** | Supported (with limit) | CTEs with `UNION` | Not supported |

## Best Practices Learned

### When to Use Lambda
✓ Short, simple operations with map/filter/sorted  
✓ One-time use, throwaway logic  
✗ Complex logic (use `def` instead)  
✗ Need docstrings or debugging

### Function Design
- Use default parameters instead of None checks
- Raise errors for invalid inputs (don't `return print()`)
- Inner functions can access outer scope (closures)
- Functions are objects (can be assigned to variables)