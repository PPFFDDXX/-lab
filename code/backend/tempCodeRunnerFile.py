if user_query(user_name, password) == -2:
            return jsonify({"status": -3, "message": "账号已存在"})  # 返回 JSON 格式