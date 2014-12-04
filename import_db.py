import sqlite3

connection = sqlite3.connect('Db.sqlite')

cursor = connection.cursor()

cursor.execute('CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, name TEXT, latitude FLOAT, longitude FLOAT, description TEXT)');

try:
	with open("coords.txt") as file:
		for line in file:
			line = line.replace("\n", "")
			temp = line.split(",")
			query_string = "INSERT INTO locations (name, latitude, longitude) VALUES ('{0}', {1}, {2})".format(temp[0], temp[1], temp[2])
			cursor.execute(query_string)
			connection.commit()
except Exception as e:
	print("Error: " + e.message)

connection.close()
