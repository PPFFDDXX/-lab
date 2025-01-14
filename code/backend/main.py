from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, text

app = Flask(__name__)

HOSTNAME = "127.0.0.1"
PORT = 3306
USERNAME = "root"
PASSWORD = "mysql123"
DATABASE = "database"

app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{USERNAME}:{PASSWORD}@{HOSTNAME}:{PORT}/{DATABASE}?charset=utf8mb4"

db = SQLAlchemy(app)#读取app.config

#连接测试代码
#with app.app_context():
#    with db.engine.connect() as conn:
#        rs = conn.execute(text("SELECT 1;"))
#        print(rs.fetchone())

@app.route('/')

def print_hi():
    return "<p>Hi, my name is HarmonyOS</p>"

@app.route('/list')#检验是否用户名及密码
def list():
    return 0


@app.route('/detail/<string:id>')#或许是某个用户？
def detail(id):
    return id
    

if __name__ == '__main__':
    app.run(debug=True)