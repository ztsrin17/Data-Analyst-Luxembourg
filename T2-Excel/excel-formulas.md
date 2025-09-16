# Excel Formulas Cheat Sheet

## Lookup Functions

### VLOOKUP
**Syntax:** `=VLOOKUP(lookup_value, table_array, col_index_num, [range_lookup])`

**Purpose:** Searches for a value in the first column of a table and returns a value in the same row from a specified column.

```excel
=VLOOKUP("Product A", A2:D100, 3, FALSE)
```
- `FALSE` = Exact match, `TRUE` = Approximate match
- Limited to searching left-to-right only
- Legacy function, consider XLOOKUP for new workbooks

### INDEX/MATCH
**Syntax:** `=INDEX(return_array, MATCH(lookup_value, lookup_array, [match_type]))`

**Purpose:** Advanced lookup combining INDEX (returns value at position) with MATCH (finds position of value).

```excel
=INDEX(D2:D100, MATCH("Product A", B2:B100, 0))
```
- More flexible than VLOOKUP (works in any direction)
- `0` = Exact match, `1` = Less than, `-1` = Greater than
- Best for dynamic column referencing

### XLOOKUP
**Syntax:** `=XLOOKUP(lookup_value, lookup_array, return_array, [if_not_found], [match_mode], [search_mode])`

**Purpose:** Modern replacement for VLOOKUP with enhanced features.

```excel
=XLOOKUP("Product A", B2:B100, D2:D100, "Not Found", 0, 1)
```
- Superior error handling with custom messages
- Bidirectional search capability
- Wildcard matching support
- Cleaner syntax than INDEX/MATCH

### HLOOKUP
**Syntax:** `=HLOOKUP(lookup_value, table_array, row_index_num, [range_lookup])`

**Purpose:** Horizontal lookup for transposed data structures.

```excel
=HLOOKUP("Q1", A1:E10, 5, FALSE)
```
- Works with horizontally arranged data
- Less common than VLOOKUP but useful for specific layouts

## Logical Functions

### IF
**Syntax:** `=IF(logical_test, value_if_true, value_if_false)`

**Purpose:** Returns different values based on whether a condition is TRUE or FALSE.

```excel
=IF(A1>100, "High", "Low")
```
- Can be nested for multiple conditions
- Foundation for complex business logic

### IFS
**Syntax:** `=IFS(logical_test1, value_if_true1, logical_test2, value_if_true2, ...)`

**Purpose:** Modern alternative to nested IF statements for multiple conditions.

```excel
=IFS(A1>1000, "Premium", A1>500, "Standard", A1>0, "Basic", TRUE, "Invalid")
```
- Cleaner than nested IF structures
- Better performance and readability
- Up to 127 condition pairs

### AND
**Syntax:** `=AND(logical1, logical2, ...)`

**Purpose:** Returns TRUE only if all conditions are TRUE.

```excel
=IF(AND(A1>50, B1<100), "Valid Range", "Invalid")
```
- All conditions must be TRUE
- Often used within IF statements

### OR
**Syntax:** `=OR(logical1, logical2, ...)`

**Purpose:** Returns TRUE if any condition is TRUE.

```excel
=IF(OR(A1="Premium", A1="Gold"), "Eligible", "Not Eligible")
```
- Any condition being TRUE triggers TRUE result
- Useful for multiple valid options

## Key Concepts

### Pivot Tables
**Definition:** Interactive data summarization tools that automatically aggregate, sort, and analyze large datasets through drag-and-drop functionality for instant business insights.

### Power Query
**Definition:** Excel's ETL (Extract-Transform-Load) engine that connects to multiple data sources, applies repeatable transformation steps, and automates data preparation workflows with visual, step-based operations.

### Slicers
**Definition:** Interactive visual filters that provide dashboard-style controls for pivot tables and charts, enabling users to dynamically filter data through clickable buttons rather than dropdown menus.

## Professional Excel Writing

### Debugging Strategies

1. **Formula Auditing Tools**
   - Use `Ctrl + `` to show all formulas
   - Trace precedents/dependents with Formula Auditing ribbon
   - F9 key to evaluate parts of complex formulas

2. **Error Handling**
   - Implement IFERROR for graceful failure handling
   - Use XLOOKUP's built-in error messaging
   - Test edge cases with empty cells and invalid inputs

3. **Systematic Breakdown**
   - Break complex formulas into intermediate steps
   - Use helper columns for transparency
   - Document formula logic with comments

### Performance Tips

1. **Formula Optimization**
   - Prefer IFS over nested IF for multiple conditions
   - Use XLOOKUP instead of VLOOKUP for new workbooks
   - Minimize volatile functions (NOW, RAND, INDIRECT)

2. **Data Structure**
   - Convert ranges to Tables for dynamic references
   - Use structured references for readability
   - Apply filters before merge/append operations in Power Query

3. **Reference Management**
   - Strategic use of absolute ($) references for scalability
   - Named ranges for improved formula readability
   - Avoid circular references

### Readability Best Practices

1. **Naming Conventions**
   - Use descriptive names for ranges and tables
   - Implement consistent formatting styles
   - Document assumptions and business logic

2. **Formula Structure**
   - Break long formulas across multiple cells
   - Use proper indentation in complex nested functions
   - Add comments for business rule explanations

### Common Pitfalls

1. **Data Type Issues**
   - Text vs number mismatches in lookups
   - Date format inconsistencies
   - Leading/trailing spaces in lookup values

2. **Reference Errors**
   - Absolute vs relative reference confusion
   - Deleted rows/columns breaking formulas
   - Cross-sheet reference vulnerabilities

3. **Logic Errors**
   - Incorrect order in nested IF statements
   - Missing edge case handling
   - Assumption failures with empty data

### Cross-Domain Knowledge

1. **Tool Selection Framework**
   - **Excel Formulas:** Small datasets, ad-hoc analysis, scenario testing
   - **Pivot Tables:** Fast summaries, drag-and-drop reporting
   - **Power Query:** Medium datasets, automated ETL workflows
   - **SQL:** Large-scale database operations, complex analytical queries

2. **Business Application**
   - Conditional pricing models and commission structures
   - Multi-tier discount systems and bulk pricing
   - Dynamic lookup systems for changing data structures
   - Dashboard design with cognitive load management (4-7 items maximum)

3. **Data Integration Strategy**
   - Power Query for multi-source data combining
   - Merge vs Append decision framework
   - Function creation for repeatable transformations
   - Version control through query duplication