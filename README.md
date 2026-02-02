# 🚀 Azure Data Engineering Projects Portfolio

...


# 🥇 Project 1: End-to-End Ingestion (ADLS → ADF → Azure SQL)

### 📌 Overview  
Built a complete Azure Data Factory pipeline to ingest a **pipe-delimited text file** from **Azure Data Lake Storage Gen2** into **Azure SQL Database**.

### 🏗 Architecture  
**ADLS (TXT)** → **Azure Data Factory** → **Azure SQL Database**

### 🎯 Key Features
- ✅ Cloud file ingestion from ADLS  
- ✅ Azure Data Factory Copy activity  
- ✅ Schema mapping & type handling  
- ✅ Structured relational storage in Azure SQL  

### 📈 Learning Outcomes
- Built a full cloud ETL pipeline  
- Practiced ADLS → ADF → Azure SQL workflow  
- Designed and validated SQL tables  

📁 **Screenshots:**  
👉 `pipelines/project-01/`

---

# 🥈 Project 2: Conditional Ingestion Pipeline (SQL → ADLS)

### 📌 Overview  
Designed a **control-flow driven Azure Data Factory pipeline** that loads data from **Azure SQL to Azure Data Lake only when the source contains more than 500 records.**

### 🏗 Architecture  
**Azure SQL** → **ADF (Lookup + If Condition)** → **ADLS**

### 🎯 Key Features
- ✅ Lookup activity to fetch source record count  
- ✅ If Condition for dynamic pipeline control  
- ✅ Conditional SQL → ADLS ingestion  
- ✅ Prevents unnecessary data loads  

### 📈 Learning Outcomes
- Implemented pre-ingestion validation logic  
- Built conditional & decision-based pipelines  
- Applied real-world orchestration patterns  

📁 **Screenshots:**  
👉 `pipelines/project2_conditional_ingestion/`

---

# 🥉 Project 3: Metadata-Driven Multi-Table Ingestion Framework (SQL → ADLS)

### 📌 Overview  
Built a **single reusable Azure Data Factory pipeline** to ingest **multiple SQL tables into Azure Data Lake** using a **metadata-driven approach**, supporting both **sequential and batch execution modes.**

### 🏗 Architecture  
**Azure SQL (Control Table)** → **ADF (Lookup + ForEach + Parameterized Copy)** → **ADLS**

### 🎯 Key Features
- ✅ Metadata-driven ingestion using a **control/config table**  
- ✅ **Single pipeline** to ingest unlimited tables  
- ✅ **ForEach orchestration** for multi-table loading  
- ✅ Supports **sequential and parallel batch execution**  
- ✅ Fully **parameterized datasets and pipelines**  
- ✅ Automatic folder & file creation in ADLS  

### 📈 Learning Outcomes
- Designed a **scalable ingestion framework**  
- Implemented **Lookup + ForEach + dynamic expressions**  
- Built **enterprise-style reusable pipelines**  
- Practiced **batch vs sequential orchestration patterns**  

📁 **Screenshots:**  
👉 `pipelines/project-03-mutilple_table_ingestion/`


# 🚀 Project 3: SCD Type 2 Implementation — Azure Data Factory

## 📌 Overview
This project implements **Slowly Changing Dimension (Type 2)** using **Azure Data Factory Mapping Data Flow** to maintain **historical data changes** inside a dimension table.

The pipeline automatically:
- Detects new records
- Detects changed records
- Expires old versions
- Inserts new versions
- Preserves full history

This design mirrors **real-world enterprise data warehouse patterns** used in analytics and reporting systems.

---

## 🏗 Architecture

<img src="images/scd2/pipeline.png" width="100%"/>

### Data Flow

```
Source → Lookup → Derived Column (Hash) → Conditional Split
       → Alter Row (Update Old)
       → Alter Row (Insert New)
       → Sink (Dimension Table)
```

---

## ⚙️ Tech Stack

- Azure Data Factory (Mapping Data Flow)
- Azure SQL Database
- SQL
- Dimensional Modeling

---

## 📂 Project Structure

```
images/
 └── scd2/
      └── pipeline.png

sql/
 └── create_tables.sql

README.md
```

---

## 🗄 Database Design

### Staging Table
Stores latest snapshot of source data.

```sql
stg_customer
```

### Dimension Table (SCD2)

```sql
dim_customer
```

### Columns

| Column | Purpose |
|--------|----------|
| surrogate_key | Unique row identifier |
| customer_id | Business key |
| name, city, email | Attributes |
| start_date | Record start date |
| end_date | Record expiry date |
| is_current | Active flag |

---

## 🔄 Data Flow Logic (Step-by-Step)

### 1️⃣ Source
Reads latest data from staging table.

---

### 2️⃣ Lookup
Matches with current records in dimension table.

Condition:
```
customer_id == dim_customer.customer_id
AND is_current == 1
```

Purpose: Identify existing active records.

---

### 3️⃣ Derived Column (Hash)
Creates hashes for change detection.

Example:
```
hash_new = sha1(name + city + email)
hash_old = sha1(dim_name + dim_city + dim_email)
```

Purpose: Efficient comparison of records.

---

### 4️⃣ Conditional Split

Routes rows into:

| Type | Condition |
|--------|-----------|
| NEW | No existing match |
| CHANGED | Hash mismatch |
| SAME | Hash match |

---

### 5️⃣ Alter Row — Expire Old Records
For **changed rows**:

```
updateIf(true())
```

Updates:
```
end_date = currentUTC()
is_current = 0
```

---

### 6️⃣ Alter Row — Insert New Records
For **new + changed rows**:

```
insertIf(true())
```

Sets:
```
start_date = currentUTC()
end_date = '9999-12-31'
is_current = 1
```

---

### 7️⃣ Sink
Loads results into dimension table with:
- Insert enabled
- Update enabled

---

## 📊 Example Result

### Initial Load

| id | city |
|----|-----------|
| 1 | Hyderabad |

### After Update

| sk | id | city | start | end | current |
|----|----|-----------|--------|--------|---------|
| 1 | 1 | Hyderabad | 2025 | 2026 | 0 |
| 2 | 1 | Bangalore | 2026 | 9999 | 1 |

History is preserved.

---

## 🎯 Key Features

- Pure Mapping Data Flow implementation
- No stored procedures
- No incremental logic
- Lookup-based matching
- Hash-based change detection
- Conditional routing
- Expire + Insert pattern
- Historical tracking

---

## 📈 Learning Outcomes

- Implemented SCD Type 2 from scratch
- Built Lookup + Conditional Split + Alter Row transformations
- Designed dimension tables with history tracking
- Practiced enterprise ETL patterns
- Worked with real-world Azure Data Factory workflows

---

## ▶️ How to Run

1. Create tables in Azure SQL
2. Import datasets into ADF
3. Deploy Mapping Data Flow
4. Run pipeline
5. Validate `dim_customer` history

---

## 📷 Screenshots

Place screenshots inside:

```
images/scd2/
```

Example:
```
pipeline.png
```

---

# ⭐ Summary

This project demonstrates a **production-style SCD Type 2 implementation** using Azure Data Factory, enabling reliable historical tracking for analytics and reporting workloads.





