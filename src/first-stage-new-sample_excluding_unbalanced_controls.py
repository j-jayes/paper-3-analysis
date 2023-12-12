# Purpose
# Create sample for first stage regression by dropping unbalanced controls

import pandas as pd

# Read in data from "data/first-stage/02_firststage-data.xlsx"
df = pd.read_excel("data/first-stage/02_firststage-data.xlsx")

df

# Read in parishes to drop from "data/balance-tests/control_parishes_dropped.xlsx"
excluded = pd.read_excel("data/balance-tests/control_parishes_dropped.xlsx")

excluded

# Create a new column called ref_code that is parish_code preceded by "SE/" if parish_code has 9 digits, or "SE/0" if parish_code has 8 digits
excluded["ref_code"] = excluded["parish_code"].apply(lambda x: "SE/" + str(x) if len(str(x)) == 9 else "SE/0" + str(x))

# Drop all rows from df where ref_code is in excluded["ref_code"]
df = df[~df["ref_code"].isin(excluded["ref_code"])]

# write to xlsx file called "data/first-stage/03_firststage-data.xlsx"
df.to_excel("data/first-stage/03_firststage-data.xlsx", index=False)

