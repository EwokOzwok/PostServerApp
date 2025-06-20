from flask import Flask, request, jsonify
import pandas as pd
import os


app = Flask(__name__)

df = pd.read_csv("Data.csv")


def pull_data(request_numb):
    user_request = df[df["Request"] == request_numb]
    output_data = user_request["Data"]
    
    return output_data

@app.route("/post_request", methods = ["POST"])
def get_data():
    # 1.) Parse incoming JSON
    payload = request.get_json(force=True)
    request_number = payload.get("request", "")
    
    # 2.) Pull Data
    try:
        output_data = pull_data(int(request_number))
    except Exception as e:
        return jsonify({"status": "post request failed", "message": str(e)}), 500
    
    data_list = output_data.tolist()
    
    return jsonify({"status": "success", "output_data": data_list}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port = 4499)


