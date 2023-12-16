#!/usr/bin/python
# -*- coding: UTF-8 -*-
# 本地测试启动 python simple_httpServer.py 8000
# 忽略挂断信号 , 默认端口 8000
# nohup python3 httpServer.py >> ../HTTP_SERVER.log 2>&1 &

# ~ https://github.com/wztshine/http_file_server
# ~ 从此仓库修改, 增加图片参数

__version__ = "0.3.0"
__all__ = ["MyHTTPRequestHandler"]

import argparse
import os
import posixpath
import time

try:
	from html import escape
except ImportError:
	from cgi import escape
import shutil
import mimetypes
import re
import signal
from io import BytesIO
import codecs

from urllib.parse import quote
from urllib.parse import unquote
from http.server import ThreadingHTTPServer
from http.server import BaseHTTPRequestHandler


class MyHTTPRequestHandler(BaseHTTPRequestHandler):
	global args

	def do_GET(self):
		"""处理 GET 请求的方法"""
		fd = self.send_head()
		if fd:
			shutil.copyfileobj(fd, self.wfile)
			fd.close()

	def do_HEAD(self):
		"""处理请求头"""
		fd = self.send_head()
		if fd:
			fd.close()

	def do_POST(self):
		"""处理 POST 请求的方法"""
		r, info = self.deal_post_data()

		f = BytesIO()
		f.write(b'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">')
		f.write(b"<html>\n<title>Upload Result Page</title>\n")
		f.write(b"<body>\n<h2>Upload Result Page</h2>\n")
		f.write(b"<hr>\n")
		if r:
			f.write(b"<strong>Success:</strong><br>")
		else:
			f.write(b"<strong>Failed:</strong><br>")
		for i in info:
			f.write(i.encode('utf-8') + b"<br>")
		f.write(b"<br><a href=\"%s\">back</a>" % self.headers['referer'].encode('utf-8'))
		f.write(b"</body>\n</html>\n")
		length = f.tell()
		f.seek(0)
		self.send_response(200)
		self.send_header("Content-type", "text/html;charset=utf-8")
		self.send_header("Content-Length", str(length))
		self.end_headers()
		if f:
			shutil.copyfileobj(f, self.wfile)
			f.close()

	def str_to_chinese(self, var):
		"""
		将url中的字符转换成中文
		"""
		not_end = True
		while not_end:
			start1 = var.find("\\x")
			if start1 > -1:
				str1 = var[start1 + 2:start1 + 4]
				start2 = var[start1 + 4:].find("\\x") + start1 + 4
				if start2 > -1:
					str2 = var[start2 + 2:start2 + 4]
					start3 = var[start2 + 4:].find("\\x") + start2 + 4
					if start3 > -1:
						str3 = var[start3 + 2:start3 + 4]
			else:
				not_end = False
			if start1 > -1 and start2 > -1 and start3 > -1:
				str_all = str1 + str2 + str3
				str_all = codecs.decode(str_all, "hex").decode('utf-8')

				str_re = var[start1:start3 + 4]
				var = var.replace(str_re, str_all)
		return var

	def deal_post_data(self):
		"""
		处理 POST 请求发来的数据，也就是客户端提交上传的文件
		"""
		boundary = self.headers["Content-Type"].split("=")[1].encode('utf-8')
		remain_bytes = int(self.headers['content-length'])

		res = []
		line = self.rfile.readline()
		while boundary in line and str(line, encoding="utf-8")[-4:] != "--\r\n":
			remain_bytes -= len(line)
			if boundary not in line:
				return False, "Content NOT begin with boundary"
			line = self.rfile.readline()
			remain_bytes -= len(line)
			# 查找上传的文件
			fn = re.findall(r'Content-Disposition.*name="file"; filename="(.*)"', str(line))
			if not fn:
				return False, "Can't find out file name..."
			path = translate_path(self.path)
			fname = fn[0]
			# ~ print(f"fname: {fname}")
			fname = self.str_to_chinese(fname)
			# ~ fname = fname.encode('utf-8').decode('utf-8')
			# ~ fname = fname.encode('unicode_escape')
			# ~ print(f"fname: {fname}")
			fn = os.path.join(path, fname)
			# 如果本地有同名文件如 test.txt，会将用户上传的文件重命名为：test_1.txt
			while os.path.exists(fn):
				try:
					name, suffix = fn.rsplit(".", 1)
					fn = name + "_1" + "." + suffix
				except ValueError:
					fn += "_1"
			dirname = os.path.dirname(fn)
			if not os.path.exists(dirname):
				os.makedirs(dirname)
			line = self.rfile.readline()
			remain_bytes -= len(line)
			line = self.rfile.readline()
			remain_bytes -= len(line)
			try:
				out = open(fn, 'wb')
			except IOError:
				return False, "Can't create file to write, do you have permission to write?"

			pre_line = self.rfile.readline()
			remain_bytes -= len(pre_line)
			Flag = True
			while remain_bytes > 0:
				line = self.rfile.readline()

				if boundary in line:
					remain_bytes -= len(line)
					pre_line = pre_line[0:-1]
					if pre_line.endswith(b'\r'):
						pre_line = pre_line[0:-1]
					out.write(pre_line)
					out.close()
					res.append(fn)
					Flag = False
					break
				else:
					out.write(pre_line)
					pre_line = line
			if pre_line is not None and Flag == True:
				out.write(pre_line)
				out.close()
				res.append(fn)
		return True, res

	def send_head(self):
		"""Common code for GET and HEAD commands.
		This sends the response code and MIME headers.

		这个方法返回一个文件对象（代表要发送给客户端的数据）或者 None（代表不做任何处理）。如果返回的是文件对象，调用者必须手动关闭这个文件。
		"""
		path = translate_path(self.path)
		if os.path.isdir(path):
			if not self.path.endswith('/'):
				self.send_response(301)
				self.send_header("Location", self.path + "/")
				self.end_headers()
				return None
			for index in "index.html", "index.htm":
				index = os.path.join(path, index)
				if os.path.exists(index):
					path = index
					break
			else:
				return self.list_directory(path)
		content_type = self.guess_type(path)
		try:
			# Always read in binary mode. Opening files in text mode may cause
			# newline translations, making the actual size of the content
			# transmitted *less* than the content-length!
			f = open(path, 'rb')
		except IOError:
			self.send_error(404, "File not found")
			return None
		self.send_response(200)
		self.send_header("Content-type", content_type)
		fs = os.fstat(f.fileno())
		self.send_header("Content-Length", str(fs[6]))
		self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
		self.end_headers()
		return f

	def list_directory(self, path):
		"""用来列出路径下所有的内容，将内容写入文件中，返回这个文件对象
		"""
		try:
			list_dir = os.listdir(path)
		except os.error:
			self.send_error(404, "No permission to list directory")
			return None
		list_dir.sort(key=lambda name: name.lower())
		list_dir.sort(key=lambda name: os.path.isfile(os.path.join(path, name)))

		f = BytesIO()
		display_path = escape(unquote(self.path))
		f.write(b'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">\n<html>\n')
		f.write(b'<head>')
		# 网页自适应手机
		f.write(b'<meta name="viewport" content="width=device-width,initial-scale=0.8, minimum-scale=0.5, maximum-scale=2, user-scalable=yes"/>')
		f.write(b'<title>File Server</title>\n')
		f.write(b'</head><body>\n')
		if args.image:
			imgpath = os.path.relpath(args.image, os.getcwd()+self.path)
			divpicture = '<div class="box"><img src="' + imgpath + '"/></div>\n'
			f.write(divpicture.encode("utf-8"))
		f.write(b"<h2>Current path: %s</h2>\n" % display_path.encode('utf-8'))
		f.write(b"<hr>\n")
		# 上传目录表单
		f.write(b"<h3>Directory Upload</h3>\n")
		f.write(b"<form ENCTYPE=\"multipart/form-data\" method=\"post\">")
		f.write(b"<input ref=\"input\" webkitdirectory multiple name=\"file\" type=\"file\"/>")
		f.write(b"<input type=\"submit\" value=\"Start Upload\"/></form>\n")
		f.write(b"<hr>\n")
		# 上传文件表单
		f.write(b"<h3>Files Upload</h3>\n")
		f.write(b"<form ENCTYPE=\"multipart/form-data\" method=\"post\">")
		f.write(b"<input ref=\"input\" multiple name=\"file\" type=\"file\"/>")
		f.write(b"<input type=\"submit\" value=\"Start Upload\"/></form>\n")
		f.write(b"<hr>\n")
		# 展示文件列表
		f.write(b"<h3>Files Listing</h3>")
		f.write(b'<table style="width: 80%">')
		f.write(b'<tr><th style="text-align: left">Path</th>')
		f.write(b'<th style="width: 20%; text-align: left">Size</th>')
		f.write(b'<th style="width: 20%; text-align: left">Modify Time</th>')
		f.write(b"</tr>")

		# 如果当前路径不是根目录，则写入一个 ../ 链接，让用户可以返回上一层目录
		if self.path != "/":
			current_url = self.path
			if current_url.endswith('/'):
				current_url = current_url[:-1]
			outer_foler_url = current_url.rsplit('/', 1)[0]
			outer_foler_url = '/' if not outer_foler_url else outer_foler_url
			f.write(
					b'<tr style="height: 30px"><td style="background-color: rgb(0,150,0,0.2)"><a href="%s">%s</a></td></tr>' % (
						quote(outer_foler_url).encode('utf-8'), "../".encode('utf-8')))

		# 列出所有的内容
		for name in list_dir:
			fullname = os.path.join(path, name)
			display_name = linkname = name

			# 如果是文件夹的话
			if os.path.isdir(fullname):
				display_name = linkname = name + '/'
				f.write(
						b'<tr style="height: 30px"><td style="background-color: rgb(0,150,0,0.2)"><a href="%s">%s</a></td></tr>' % (
							quote(linkname).encode('utf-8'), escape(display_name).encode('utf-8')))

			# 如果是链接文件
			elif os.path.islink(fullname):
				linkname = linkname + "/"
				display_name = name + "@"
				# Note: a link to a directory displays with @ and links with /
				f.write(
						b'<tr style="height: 30px; background-color: rgb(150,0,0,0.2)"><td><a href="%s">%s</a></td></tr>' % (
							quote(linkname).encode('utf-8'), escape(display_name).encode('utf-8')))
			else:
				# 其他类型的文件，计算文件大小和修改时间，直接显示出来
				st = os.stat(fullname)
				fsize = st.st_size
				fsize = round(fsize / 1024, 2)
				if fsize < 1024:
					size_info = f"{fsize:<6}KB"
				elif fsize < (1024 * 1024):
					size_info = f"{round(fsize / 1024, 2):<6}MB"
				else:
					size_info = f"{round(fsize / 1024 / 1024, 2):<6}GB"

				fmtime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(st.st_mtime))
				f.write(b'<tr style="height: 30px">')
				f.write(b'<td style="background-color: rgb(150,150,0,0.2)"><a href="%s">%s</a></td>' % (
					quote(linkname).encode('utf-8'), escape(display_name).encode('utf-8')))
				f.write(b'<td><pre>%s</pre></td>' % bytes(size_info, encoding='utf-8'))
				f.write(b'<td><pre>%s</pre></td>' % escape(fmtime).encode('utf-8'))
				f.write(b"</tr>")

		f.write(b"</table>")
		f.write(b"\n<hr>\n</body>\n</html>\n")
		length = f.tell()
		f.seek(0)
		self.send_response(200)
		self.send_header("Content-type", "text/html;charset=utf-8")
		self.send_header("Content-Length", str(length))
		self.end_headers()
		return f

	def guess_type(self, path):
		"""Guess the type of a file.
		Argument is a PATH (a filename).
		Return value is a string of the form type/subtype,
		usable for a MIME Content-type header.
		The default implementation looks the file's extension
		up in the table self.extensions_map, using application/octet-stream
		as a default; however it would be permissible (if
		slow) to look inside the data to make a better guess.
		"""

		base, ext = posixpath.splitext(path)
		if ext in self.extensions_map:
			return self.extensions_map[ext]
		ext = ext.lower()
		if ext in self.extensions_map:
			return self.extensions_map[ext]
		else:
			return self.extensions_map['']

	if not mimetypes.inited:
		mimetypes.init()  # try to read system mime.types
	extensions_map = mimetypes.types_map.copy()
	extensions_map.update({
		'': 'application/octet-stream',  # Default
		'.py': 'text/plain',
		'.c': 'text/plain',
		'.h': 'text/plain',
	})


def translate_path(path):
	"""将带有 / 的网络 URL 转换成本地文件路径
	"""
	global args
	# abandon query parameters
	path = path.split('?', 1)[0]
	path = path.split('#', 1)[0]
	path = posixpath.normpath(unquote(path))
	words = path.split('/')
	words = filter(None, words)
	path = args.path.replace('"', "")
	for word in words:
		drive, word = os.path.splitdrive(word)
		head, word = os.path.split(word)
		if word in (os.curdir, os.pardir):
			continue
		path = os.path.join(path, word)
	return path


def signal_handler(signal, frame):
	exit()


def get_host_ip():
	"""
	查询本机ip地址
	:return: ip
	"""
	import socket
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.connect(('8.8.8.8', 80))
	ip = s.getsockname()[0]
	s.close()
	return ip


def main():
	global args
	server_address = (args.bind, args.port)

	signal.signal(signal.SIGINT, signal_handler)
	signal.signal(signal.SIGTERM, signal_handler)

	httpd = ThreadingHTTPServer(server_address, MyHTTPRequestHandler)
	server = httpd.socket.getsockname()
	# ~ 增加 http:// 前缀, 方便鼠标 ctrl 点击打开浏览器。
	print(f"Serveing HTTP on: http://{server[0]}:{server[1]}")
	print(f"Local IP Address: http://{get_host_ip()}:{args.port}")
	httpd.serve_forever()


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('-p', "--port", action='store', default=8000, type=int,
			help='Specify alternate port [default: 8000]')
	parser.add_argument('--path', action='store', default=os.getcwd(), help='Specify the folder path to share')
	parser.add_argument('--bind', '-b', metavar='ADDRESS', default='0.0.0.0',
			help='Specify alternate bind address [default: "0.0.0.0"]')
	parser.add_argument('-i', '--image', action='store', default='', type=str,
            help='set the picture')
	args = parser.parse_args()
	if args.image:
		# ~ 图片参数文件, 获取全长绝对路径
		if os.path.exists(args.image):
			args.image = os.path.abspath(os.path.expanduser(args.image))
		else:
			args.image = None
	if os.path.isfile(args.path):
		raise NotADirectoryError("--path argument should specify a folder path, not a file.")
	if not os.path.exists(args.path):
		raise FileExistsError("--path argument path not exists.")

	main()
