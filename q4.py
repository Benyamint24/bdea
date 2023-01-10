# a python script can be like below:

import os
import time

import mysql.connector
from prometheus_client import start_http_server, Gauge

MYSQL_USER = os.getenv("USER")
MYSQL_PASSWORD = os.getenv("PASSWORD")
MYSQL_HOST = os.getenv("HOST")
MYSQL_PORT = os.getenv("PORT")

gauge = Gauge("mysql_active_connections", "Number of active connections")
query = "SELECT COUNT(*) FROM information_schema.processlist WHERE command <> 'Sleep'"

def get_active_connections():
	connection = mysql.connector.connect(user=MYSQL_USER, password=MYSQL_PASSWORD, host=MYSQL_HOST, port=MYSQL_PORT)
	cursor = connection.cursor()
	cursor.execute(query)
	result = cursor.fetchone()
	active_connections = int(result[1])
	gauge.set(active_connections)

if __name__ == "__main__":
    start_http_server(8000)
    while True:
        get_active_connections()
        time.sleep(10)
