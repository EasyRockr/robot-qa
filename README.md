# robot-qa

# Robot‑QA: React Admin Demo – Automation Suite

This repository contains Robot Framework tests that automate the **React Admin demo** customer workflow end‑to‑end — from creating customers using API data to verifying table displays, updating existing rows, logging row data, and analyzing total customer spending.

> **Status:** All tasks (1–5) and all detailed requirements (items 1–10) are accomplished as specified.

---

## ✅ Task Checklist (All Achieved)

### Task 1 — Add First 5 Users
1. **Fetch users** from `https://jsonplaceholder.typicode.com/users` via `Library/CustomLibrary.py` → `get_random_customers()` ✔️  
2. **Create first 5** users as customers (no args = first 5). ✔️  
3. **Verify** per user: name, email, birthday, address, city, stateAbbr, zipcode, password/confirm_password all match API‑derived data. ✔️

### Task 2 — Verify Table Display
4. **Confirm the 5 newly created** customers appear in the table; open each created row by index and re‑verify inputs. ✔️

### Task 3 — Update Existing Customers
5. **Use users 6–10** from the API data set. ✔️  
6. **Update table rows 6–10** with those users. ✔️  
7. **Replace all fields** (clear‑then‑type) so values are overwritten, not appended. ✔️

### Task 4 — Log Table Data
8. **Log every row** in the exact format (Name, Last Seen, Orders, Total Spent, Latest Purchase, News, Segment). ✔️

### Task 5 — Analyze User Spending
9. **List spenders (> $0)** in numbered order with amounts. ✔️  
10. **Compute total** and **validate** against `$3,500`; print **PASS/FAIL** and fail the test when below threshold. ✔️

---

## Project Structure

```
robot-qa/
├─ Library/
│  └─ CustomLibrary.py               # API fetch, data helpers
├─ Resources/
│  ├─ App.resource                   # Common app-level keywords
│  ├─ Login.resource                 # Login helpers
│  └─ CustomerPageResources/
│     ├─ CustomerPage.resource       # Page keywords (create/verify/open)
│     ├─ Task_1.resource             # Task 1 keywords
│     ├─ Task_2.resource             # Task 2 keywords
│     ├─ Task_3.resource             # Task 3 keywords
│     ├─ Task_4.resource             # Task 4 keywords (log table rows)
│     └─ Task_5.resource             # Task 5 keywords (spending analysis)
├─ Variables/
│  ├─ variables.py                   # URL/credentials
│  └─ customerpage.py                # Centralized selectors (XPath)
├─ Tests/
│  └─ test.robot / customer_page_test.robot
└─ Results/                          # Run artifacts (ignored by .gitignore)
```

---

## How to Run

```bash
# From repo root
robot -d Results ./Tests/test.robot
# or
robot -d Results ./Tests/customer_page_test.robot
```

- Artifacts will be in `Results/` (`output.xml`, `log.html`, `report.html`, screenshots).

---

## Design & Implementation Notes

### Centralized Selectors (Single Source of Truth)
All table locators are defined in **`Variables/customerpage.py`**. Row‑based XPaths use `%s` placeholders and are formatted in Robot via `${selector % ${r}}`. Examples:

```python
# Variables/customerpage.py
table_row                 = '//table//tbody//tr'
name_selector             = '//table//tbody//tr[%s]//td[2]//a'
name_fallback_selector    = '//table//tbody//tr[%s]//td[2]//a//*[self::span or self::p][last()]'
last_seen_selector        = '//table//tbody//tr[%s]//td[3]'
orders_selector           = '//table//tbody//tr[%s]//td[4]'
total_spent_selector      = '//table//tbody//tr[%s]//td[5]'
latest_purchase_selector  = '//table//tbody//tr[%s]//td[6]'
news_selector             = '//table//tbody//tr[%s]//td[7]//*[name()="svg"]'
segment_selector          = '//table//tbody//tr[%s]//td[8]//span[contains(@class,"MuiChip-label")]'
```

### Table Traversal & Name Extraction
- Iterate with `FOR  ${r}  IN RANGE  1  ${row_count + 1}` to use 1‑based indices.  
- For names, use a **fallback**:
  1) Try `${name_fallback_selector % ${r}}` (last span/p element under the link), else  
  2) Read `${name_selector % ${r}}` and take the last line.

### Segments (Chips)
Collect chip texts using `${segment_selector % ${r}}` with `Get WebElements`, then `Get Text` per chip and `Catenate` with commas.

### Spending Analysis
- Read `${total_spent_selector % ${r}}` (e.g., `$1,200`).  
- Strip `$` and `,`, convert to number; only log if `> 0`.  
- Sum all rows and compare to threshold `$3,500`, printing **PASS/FAIL** and failing on FAIL.

### Variable Scope
- `${customers}` and `${Verified_Customers}` are **promoted to suite scope** in Task 1 before use in later tasks.  
- Each verified record is appended to `${Verified_Customers}` after `Verify Customer Input`.

### Update Behavior (Replace, Don’t Append)
- Update keywords **clear each input** before typing new values to ensure replacement, not concatenation.

---

## Example Console Output (Abbreviated)

```
====== User 1 ======
Name: Glenna Reichert
Last seen: 2023-09-24
Orders: 5
Total spent: $277.83
Latest purchase: ...
News: Yes
Segment: Regular, VIP
--------------------------------------------
...

1. Glenna Reichert: $277.83
2. Helene Torp: $1,245.50
3. Eino Ernser: $283.76
=========================
Total Customer Spending: $3,812.09
=========================
PASS: Total Spending ($3,812.09) meets minimum threshold ($3,500)
```

---

## .gitignore (Safe Defaults)

```
__pycache__/
*.pyc
*.pyo
*.pyd
*.egg-info/
.env
.venv/
venv/

# Robot/Selenium artifacts
Results/
output.xml
log.html
report.html
selenium-screenshot-*.png

# IDE/OS
.vscode/
.idea/
.DS_Store
Thumbs.db
*.swp
*.swo
```

> Keep all source files tracked: `Library/`, `Resources/`, `Variables/`, and `Tests/`.

---

## Notes

- Uses **Robot Framework + SeleniumLibrary** with Chrome.  
- All locators centralized; dynamic row selection via `%s` formatting prevents malformed XPaths.  
- Tests are modular: each task is encapsulated under `Resources/CustomerPageResources/Task_*.resource` and orchestrated from `Tests/`.

---

**Author:** Automation Suite generated and validated for the React Admin demo customer workflows.
