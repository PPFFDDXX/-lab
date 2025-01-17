from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, text
from datetime import datetime

app = Flask(__name__)

HOSTNAME = "127.0.0.1" # 数据库host
PORT = 3306 # 数据库端口号
USERNAME = "root" # 用户名
PASSWORD = "" # mysql密码   
DATABASE = "harmony"  # 数据库名称


app.config["SQLALCHEMY_DATABASE_URI"] = f"mysql+pymysql://{USERNAME}:{PASSWORD}@{HOSTNAME}:{PORT}/{DATABASE}?charset=utf8mb4" #配置

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

class DETAIL(db.Model):
    __table_name__ = "DETAIL"

    user_name = db.Column(db.String(100), nullable = False)
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    bill_type = db.Column(db.Integer, nullable = False)
    money = db.Column(db.Float, nullable = False)
    content = db.Column(db.String(200))
    date = db.Column(db.String(100), nullable = False)

with app.app_context():#获取上下文
    db.create_all()

@app.route("/test")#单元测试用接口
def test():
    # new_one = DETAIL(user_name = "hxy", bill_type = 0, money = 100000000, content = "", date = "2025-01-15")
    # db.session.add(new_one)
    # db.session.commit()
    # assert (get_data("hxy").get_json()["datas"][0]["money"] == 100000000)
    # detail = DETAIL.query.filter_by(user_name="hxy").first()
    # db.session.delete(detail)
    # db.session.commit()
    return "200"

# @app.route('/api/user/add')
def user_add(user_name, password):
# 添加用户名
    new_one = USER(user_name = user_name, password = password)
    db.session.add(new_one)
    db.session.commit()

    return "200"

# @app.route('/api/user/query')
def user_query(user_name, password):
#查询是否存在该用户

    users = USER.query.filter_by(user_name = user_name)# 得到一个Query对象，用于返回某人全部数据，可以使用for in
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


# @app.route("/api/detail/<string:id>")#或许是某个用户？
# def detail(user_id):
#     return id
    
@app.route("/api/update_user")
def user_update():
    # 实现修改密码
    json_data = request.get_json()

    user_name = json_data["user_name"]
    password = json_data["password"]

    user = USER.query.filter_by(user_name = user_name).first()
    user.password = password
    db.session.commit()

    return "200"

@app.route("/api/add", methods=["POST"])
def detail_add():
    #添加某条数据
    # print("add!")
    json_data = request.get_json()
    # 读取数据
    user_name = json_data["user_name"]
    bill_type = json_data["type"]
    money = json_data["money"]
    content = json_data["content"]
    date = json_data["date"]

    new_one = DETAIL(user_name = user_name, bill_type = bill_type, money = money, content = content, date = date)
    db.session.add(new_one)
    db.session.commit()

    return jsonify({"status": 200})

@app.route("/api/delete", methods=["POST"])
def detail_delete():
    #删除某条数据
    json_data = request.get_json()
    user_id = json_data["id"]
    
    detail = DETAIL.query.filter_by(id = user_id).first()
    db.session.delete(detail)
    db.session.commit()
    return "200"

@app.route("/api/update", methods=["POST"])
def detail_update():
    #修改某条数据
    json_data = request.get_json()
    #读取数据
    user_id = json_data["id"]
    bill_type = json_data["type"]
    money = json_data["money"]
    content = json_data["content"]
    date = json_data["date"]
    #写入数据
    detail = DETAIL.query.filter_by(id = user_id).first()
    detail.bill_type = bill_type
    detail.money = money
    detail.content = content
    detail.date = date
    db.session.commit()

    return "200"

@app.route("/api/sign", methods=["POST"])
def sign():
    # print("sign")
    json_data = request.get_json()
    # 读取数据
    is_sign_up = json_data["is_sign_up"]
    user_name = json_data["user_name"]
    password = json_data["password"]
    print(f"getdata:\nis_sign_up:{is_sign_up}\nuser_name:{user_name}\npassword:{password}")

    if is_sign_up:
        # print("开始注册")
        # 下面的判断用户已存在存在问题,如需要查看可以注释掉下面两行
        if user_query(user_name, password) != -2:
            return jsonify({"status": -3, "message": "账号已存在"})  # 需要返回 JSON 格式
        # print("没有这个用户")
        # 注册用户
        user_add(user_name, password)
        return jsonify({"status": 0, "message": "注册成功"})
    else:
        # 如果用户不存在
        if user_query(user_name, password) == -2:
            return jsonify({"status": -2, "message": "用户不存在"})

        # 如果密码错误
        elif user_query(user_name, password) == -1:
            return jsonify({"status": -1, "message": "密码错误"})

        # 登录成功
        else:
            return jsonify({"status": 0, "message": "登录成功"})

@app.route("/api/get_data/<string:user_name>",methods=['GET'])
def get_data(user_name):
    #前端获取数据
    details = DETAIL.query.filter_by(user_name = user_name).order_by(DETAIL.date, DETAIL.id)
    
    json = {}
    json["status"] = 200
    
    datas = []
    for detail in details:
        data = {}

        data["user_name"] = detail.user_name
        data["id"] = detail.id
        data["type"] = detail.bill_type
        data["money"] = detail.money
        data["content"] = detail.content
        # data["date"] = datetime.strftime(detail.date, "%Y-%m-%d")
        data["date"] = detail.date
        datas.append(data)
    print(datas)
    json["datas"] = datas

    return jsonify(json)

# status, data = get_data(user_name)

if __name__ == "__main__":
    app.run(debug=True)
