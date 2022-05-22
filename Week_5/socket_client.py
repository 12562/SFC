import socket
HOST = socket.gethostname()
PORT = 10002
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
s.send(b'Hello World')
data = s.recv(1024)
s.close()
print('Received: ', repr(data))
