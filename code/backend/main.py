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

class USER(db.Model):#固定写法
    __tabelname__ = "USER"
    #id = db.Column(db.Integer, primary_key = True, autoincrement = True)#用不上或许？
    username = db.Column(db.String(100), primary_key = True, nullable = False)
    password = db.Column(db.String(100), nullable = False)

#user = USER(username = "somebody", password = "123")
#自动映射 sql: insert user(username, password) values ("somebody", "123")

class DETAIL(db.Model):
    __tabelname__ = "DETAIL"
    username = db.Column(db.String(100), nullable = False)
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    

with app.app_context():#获取上下文
    db.create_all()

@app.route('/')

def print_hi():
    return "<p>Hi, my name is HarmonyOS</p>"

@app.route('/api/list')#检验是否用户名及密码
def list():
    return 0


@app.route('/api/detail/<string:id>')#或许是某个用户？
def detail(id):
    return id
    
@app.route('/api/user/add')
def user_add():
    new_one = USER(username = "someone", password = "111222333")
    db.session.add(new_one)
    db.session.commit()
    return "new one added"

@app.route('/api/user/query')
def user_query():
    #user = USER.query.get("someone")#get主键查找，用于查找账号密码,得到一条数据
    users = USER.query.filter_by(username = "someone")#得到一个Query对象，用于返回某人全部数据，可以使用for in
    return "query"
    
@app.route('/api/user/update')
def user_update():
    user = USER.query.filter_by(username = "someone")
    user.password = "new"
    db.session.commit()
    return "update"

@app.route('/api/detail/delete/<integer:id>')
def detail_delete(id):
    
    with db.engine.connect() as conn:
        rs = conn.execute(text(f"delete from detail where id = {id}"))
    #detail = DETAIL.query.filter_by(id = 2).first()
    #db.session.delete(detail)
    #db.session.commit()
    return "delete"

if __name__ == '__main__':
    app.run(debug=True)