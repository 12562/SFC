
# Import required module/s
import socket
import select
import sys
from io import StringIO


HOST = '127.0.0.1'
PORT = 24680


def connectToServer(HOST, PORT):
	"""Create a socket connection with the Server and connect to it.

	Parameters
	----------
	HOST : str
		IP address of Host or Server, the Client needs to connect to
	PORT : int
		Port address of Host or Server, the Client needs to connect to

	Returns
	-------
	socket
		Object of socket class for connecting and communication to Server
	"""

	server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	server_socket.connect((HOST, PORT))

	return server_socket


if __name__ == '__main__':
	"""Main function, code begins here
	"""

	# Define constants for IP and Port address of the Server to connect to.
	# NOTE: DO NOT modify the values of these two constants
	HOST = '127.0.0.1'
	PORT = 24680

	# Start the connection to the Server
	connected = False
	server_socket = None
	while not connected:
		try:
			server_socket = connectToServer(HOST, PORT)
			connected = True
		except Exception:
			pass	# Do noting, but try again
			# print("*** Start the server first! ***")
	
	# Receive the data sent by the Server and provide inputs when asked for.
	# if server_socket != None:
	test_file_name = sys.argv[1]
	input_file = open(test_file_name, 'r')

	while True:

		data_recvd = server_socket.recv(1024).decode('utf-8')
		print(data_recvd)

		if '>>>' in data_recvd:
			data = input_file.readline().strip(); print(data)
			read_data_from_file = StringIO(data)
			stdin = sys.stdin
			sys.stdin = read_data_from_file
			data_to_send = input()
			server_socket.sendall(data_to_send.encode('utf-8'))
			sys.stdin = stdin
		
		if not data_recvd:
			server_socket.close()
			break
	
	server_socket.close()
