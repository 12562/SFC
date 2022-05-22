import sqlite3
from sqlite3 import Error
def create_connection(db_file):
    # function to create an SQLite database
    conn = None
    try:
         conn = sqlite3.connect(db_file)
         print(sqlite3.version)
    except Error as e: 
         print(e)
    #finally:
    #     if conn:
    #conn.close()
    return conn

mydb = create_connection(r'./database')
c = mydb.cursor()
#create a table of students
#c.execute('''CREATE TABLE students (
#rollnumber int, 
#firstname varchar(10),
#surname varchar(10),
#DOB date)
#''')     
#insert data into this table
c.execute('''INSERT INTO students VALUES (1540,
'diptesh','kanojia','2/11/1987')''')
# Make sure you are inserting data in the right order and with an appropriate data type.
#Save changes using the commit() function
mydb.commit()
print(c.execute('''SELECT * FROM students''').fetchall())
print(c.execute('''SELECT count(*) FROM students''').fetchall())
#The output should be like:
# (1540,'diptesh','kanojia','2/11/1987')
# Close the database connection
mydb.close()
