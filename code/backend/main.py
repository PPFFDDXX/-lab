from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, text

app = Flask(__name__)

HOSTNAME = "127.0.0.1"
PORT = 3306
USERNAME = "root"
PASSWORD = "mysql123"
DATABASE = "harmony"

app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{USERNAME}:{PASSWORD}@{HOSTNAME}:{PORT}/{DATABASE}?charset=utf8mb4"

db = SQLAlchemy(app)#读取app.config

#连接测试代码
with app.app_context():
    with db.engine.connect() as conn:
        rs = conn.execute(text("SELECT 1;"))
        print(rs.fetchone())

class USER(db.Model):#固定写法
    __table_name__ = "USER"
    #id = db.Column(db.Integer, primary_key = True, autoincrement = True)#用不上或许？
    user_name = db.Column(db.String(100), primary_key = True, nullable = False)
    password = db.Column(db.String(100), nullable = False)

#user = USER(username = "somebody", password = "123")

class DETAIL(db.Model):
    __table_name__ = "DETAIL"
    user_name = db.Column(db.String(100), nullable = False)
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    

with app.app_context():#获取上下文
    db.create_all()


# @app.route('/api/user/add')
def user_add(user_name, password):
# 添加用户名
    new_one = USER(user_name=user_name, password=password)
    db.session.add(new_one)
    db.session.commit()
    return "success"

# @app.route('/api/user/query')
def user_query(user_name, password):
#查询是否存在该用户

    users = USER.query.filter_by(user_name=user_name)# 得到一个Query对象，用于返回某人全部数据，可以使用for in
    if users.count() == 0:
        return -2#用户不存在
    else:
        if users.first().password == password:
            return 0#成功
        else:
            return -1#密码错误


@app.route('/')

def print_hi():
    return "<p>Hi, my name is HarmonyOS</p>"

# @app.route('/api/list')#检验是否用户名及密码
# def list():
#     return 0


@app.route('/api/detail/<string:id>')#或许是某个用户？
def detail(user_id):
    return id
    
@app.route('/api/update_user')
def user_update():
    # 实现修改密码
    json_data = request.get_json()
    user_name = json_data['user_name']
    password = json_data['password']
    user = USER.query.filter_by(user_name=user_name).first()
    user.password = password
    db.session.commit()
    return "success"

@app.route('/api/add')
def detail_add():
    #添加某条数据
    json_data = request.get_json()
    #todo

@app.route('/api/delete')
def detail_delete():
    #删除某条数据
    json_data = request.get_json()
    with db.engine.connect() as conn:
        rs = conn.execute(text(f"delete from detail where id = {id}"))
    detail = DETAIL.query.filter_by(id = 2).first()
    db.session.delete(detail)
    db.session.commit()
    return "delete"
@app.route('/api/update')
def detail_update():
    #修改某条数据
    json_data = request.get_json()
    #todo
@app.route('/api/sign')
def sign():
    #登陆处理
    json_data = request.get_json()
    is_sign_up = json_data['is_sign_up']
    user_name = json_data['user_name']
    password = json_data['password']
    if is_sign_up:
        user_add(user_name,password)
    else:
        if user_query(user_name,password)==-2:
            return "该用户不存在"
        elif user_query(user_name,password)==-1:
            return "密码错误"
        else:
            #todo 传递数据
            return "登陆成功！"

@app.route('/api/get_data/<string:user_name>')
def get_data(user_name):
    #前端获取数据
    user = USER.query.filter_by(user_name=user_name)
    #todo

if __name__ == '__main__':
    app.run(debug=True)