import sqlite3
import pandas as pd
from pathlib import Path

# Project base directory
BASE_DIR = Path(__file__).resolve().parent

# Database path (one level above project folder)
db_path = BASE_DIR.parent / "hospital_readmissions.db"

# SQL and output folders
sql_dir = BASE_DIR / "sql"
output_dir = BASE_DIR / "outputs"

# Connect to database
conn = sqlite3.connect(db_path)

# Loop through all SQL files
for sql_file in sorted(sql_dir.glob("*.sql")):
    print(f"Running {sql_file.name}...")

    with open(sql_file, "r") as f:
        query = f.read()

    df = pd.read_sql(query, conn)

    output_file = output_dir / f"{sql_file.stem}.csv"
    df.to_csv(output_file, index=False)

    print(f"Saved to {output_file}")

conn.close()
print("All queries executed successfully.")
