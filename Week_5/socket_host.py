import socket
HOST = socket.gethostname()
PORT = 10002
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
connection, address = s.accept()
print('Connected by Client IP: ', address)
while True:
      data = connection.recv(1024)
      if not data: break
      connection.send(data)
connection.close()
