

# RealEstateDataCleaning
Here's a brief walkthrough of the steps I took to clean real estate housing data:🛠️ Tech Stack & SQL Concepts Demonstrated

• Language: SQL (Microsoft SQL Server / PostgreSQL compatible)
• Advanced Techniques: Common Table Expressions (CTEs), Window Functions (ROW_NUMBER(), PARTITION BY)
• String Manipulation: SUBSTRING, CHARINDEX, PARSENAME / PARSE
• Data Transformation: CASE Statements, ALTER TABLE, DROP COLUMN, Type Casting (CONVERT/CAST)

**Data Cleaning Pipeline & Implementation Details**

**Data Formatting:**
Using the converted query, I transformed the date format and populated the property address.

**Address Parsing:**
I separated the property address into distinct components such as Address, City, and State. To achieve this, I utilized a combination of SUBSTRING, CHARINDEX, and PARSE functions.

**Data Transformation:**
Employing case statements, I standardized the representation of certain values. For instance, I replaced "Y" with "Yes" and "N" with "No" for better clarity.

**Duplicate Removal:**
To eliminate duplicate entries, I utilized a Common Table Expression (CTE), along with row numbers and partition by functions.

**Column Cleanup:**
Finally, I removed inoperable columns from the dataset using the Alter Table and Drop Column functions.
I aimed to streamline and enhance the quality of the real estate housing data through these steps. If you have any question you can always reach out to me 
Thanks 
