from flask import Flask, jsonify, request
import mysql.connector
from flask_cors import CORS
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token, get_jwt_identity, jwt_required, JWTManager
import os
from datetime import date, datetime, timedelta
import sys
import random
import json

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True, expose_headers=["Authorization"], allow_headers=["Authorization", "Content-Type"])
bcrypt = Bcrypt(app)

app.config["JWT_SECRET_KEY"] = "9ffea8ed6000588278edc942e403fa0879a341bc124f47b3"

jwt = JWTManager(app)

temp_users = {}
timeout_min = 1

try:
    con = mysql.connector.connect(
        host = 'localhost',
        user = 'thaiVote',
        password = '12345678@',
        database = 'virtual_elec_booth'
    )
    if con.is_connected():
        print("Successfully connected to DB.")

except mysql.connector.Error as e:
    print(f"Error!!! connecting to MySQL: {e}")
    sys.exit(1)

def hashPWD(password):
    return bcrypt.generate_password_hash(password).decode('utf-8')

def genOTP():
    otp = ""
    for i in range(4):
        otp += str(random.randint(0,9))
    print(f"Generated OTP: {otp}")
    return otp

def sentOTP(phoneNUM, otp_code):
    print("-----------------------------------------------------")
    print("From ThaiVote")
    print(f"To {phoneNUM}")
    print(f"Your OTP is {otp_code}")
    print("Please use this OTP to verify the account.")
    print("This OTP is valid for 1 minute")
    print("-----------------------------------------------------")
    return True

@app.route('/register', methods = ['POST'])
def register():
    data = request.get_json()

    if not data or not all(k in data for k in ['National_ID', 'Phone_no', 'DOB']):
        return jsonify({"error": "Missing Information"}), 400
        
    national_id = data['National_ID']
    phone_no = data['Phone_no']
    dob = data['DOB']
    try:
        dobb = datetime.strptime(dob, '%Y-%m-%d').date()
        today = datetime.now().date()

        age = today.year - dobb.year - ((today.month, today.day) < (dobb.month, dobb.day))
        
        if age < 18:
            return jsonify({"error": "Can not register due to age restriction. Users must be 18 or older."}), 403
            
    except ValueError:
        return jsonify({"error": "Expected YYYY-MM-DD."}), 400

    try:
        with con.cursor() as cursor:
            cursor.execute("SELECT National_ID FROM Citizen_list WHERE National_ID = %s", (national_id,))
            if cursor.fetchone():
                return jsonify({"error": "National ID is already registered."}), 409
    except mysql.connector.Error as err:
        return jsonify({"error": f"Database check error: {err}"}), 500

    otp = genOTP()
    
    temp_users[national_id] = {'data': data, 'otp': otp, 'timestamp': datetime.now()}
    
    otp_success = sentOTP(phone_no, otp)

    if otp_success:
        return jsonify({"message": "OTP sent successfully.", "id": national_id, "otp_sent": True}), 200
    else:
        del temp_users[national_id]
        return jsonify({"error": "Failed to send OTP.", "otp_sent": False}), 500

@app.route('/verify_otp', methods = ['POST'])
def verify_otp():
    data = request.get_json()

    if not data or not all(k in data for k in ['National_ID', 'otp']):
        return jsonify({"error": "Missing Informatio"}), 400
        
    national_id = data['National_ID']
    submitted_otp = data['otp']

    if national_id not in temp_users:
        return jsonify({"error": "No registration."}), 404

    user_entry = temp_users[national_id]
    
    stored_data = user_entry['data'] 
    stored_otp = user_entry['otp']
    timestamp = user_entry['timestamp']

    if datetime.now() > timestamp + timedelta(minutes = timeout_min):
        del temp_users[national_id]
        return jsonify({"error": "OTP has expired."}), 408
    
    if submitted_otp != stored_otp:
        return jsonify({"error": "Invalid OTP."}), 401

    try:
        with con.cursor() as cursor:
            insert_query = "INSERT INTO Citizen_list (National_ID, Phone_no, DOB) VALUES (%s, %s, %s)"
            cursor.execute(insert_query, (stored_data['National_ID'], stored_data['Phone_no'], stored_data['DOB']))

        con.commit()
        
        del temp_users[national_id]
        
        return jsonify({
            "message": "Verification successful.", 
            "id": national_id
            }), 201
        
    except mysql.connector.Error as err:
        con.rollback()
        return jsonify({
            "error": f"Database error: {err}"
            }), 500

@app.route('/get_user_id', methods=['GET'])
def get_user_id():
    national_id = request.args.get('national_id')
    
    if not national_id:
        return jsonify({
            "error": "Missing required parameter",
            "details": "The 'national_id' query parameter must be provided (e.g., /get_user_id?national_id=1234567890)."
        }), 400
    
    sql_query = "SELECT User_ID FROM virtual_elec_booth.Citizen_list WHERE National_ID = %s;"
    
    try:
        with con.cursor() as cursor:
            cursor.execute(sql_query, (national_id,))
            result = cursor.fetchone()
        
        if result:
            user_id = result[0]
            return jsonify({
                "user_id": user_id, 
                "message": f"User ID successfully retrieved for National ID ending in {national_id[-4:]}"
            }), 200
        else:
            return jsonify({
                "error": "Citizen not found",
                "details": f"No registered User ID found for National ID {national_id}."
            }), 404
        
    except Exception as e:
        print(f"Database operation failed: {e}", file=sys.stderr)
        return jsonify({
            "error": "Database Query Failed",
            "details": str(e)
        }), 500

@app.route('/createaccount', methods = {'POST'})
def createAcc():
    data = request.get_json()
    
    if not data or not all(k in data for k in ['userid', 'username', 'password', 'confirmPWD']):
        return jsonify({"error": "Missing Information"}), 400

    userid = data['userid']
    username = data['username']
    password = data['password']
    confirmPWD = data['confirmPWD']
    userDOB = None

    try:
        if not con.is_connected():
            con.reconnect()

        dob_query = "SELECT DOB FROM Citizen_list WHERE User_ID = %s;"
        with con.cursor() as cursor:
            cursor.execute(dob_query, (userid,))
            dob_result = cursor.fetchone()

        if not dob_result:
             return jsonify({"error": "UserID not pre-verified."}), 403
        
        user_dob = dob_result[0]

        with con.cursor() as cursor:
            cursor.execute("SELECT username FROM Registered_voters WHERE username = %s", (username,))
            if cursor.fetchone():
                return jsonify({"error": "Username is already registered."}), 409
    
    except mysql.connector.Error as err:
        return jsonify({"error": f"Database check error: {err}"}), 500
    
    if password != confirmPWD:
        return jsonify({"error": "Password not Match"}), 400
    
    try:
        with con.cursor() as cursor:
            insert_query = "INSERT INTO Registered_voters (username, encrypted_pass, DOB, UserID) VALUES (%s, %s, %s, %s)"
            cursor.execute(insert_query, (username, hashPWD(password), user_dob, userid))

        con.commit()
                
        return jsonify({
            "message": "Register successful.", 
            "username": username
            }), 201
        
    except mysql.connector.Error as err:
        con.rollback()
        return jsonify({
            "error": f"Database error: {err}"
            }), 500

@app.route('/vote', methods = ['POST'])
@jwt_required()
def vote():
    voter_ID = get_jwt_identity()
    data = request.get_json()

    if not data or 'Candidate_ID' not in data:
        return jsonify({"error": "No Candidate has been chosen"}), 400

    candidate_ID = data['Candidate_ID']

    try:
        if not con.is_connected():
            con.reconnect()

        with con.cursor(dictionary=True) as cursor:
            check_query = "SELECT has_voted FROM Registered_voters WHERE voter_ID = %s"
            cursor.execute(check_query, (voter_ID,))
            voter_status = cursor.fetchone()

            if not voter_status:
                return jsonify({"error": "Voter not found"}), 404

            if voter_status['has_voted'] == 'Y':
                return jsonify({"error": "This user has already voted"}), 403 

            update_result_query = "UPDATE result SET number_voted = number_voted + 1 WHERE CandidateID = %s"
            cursor.execute(update_result_query, (candidate_ID,))

            if cursor.rowcount == 0:
                 con.rollback()
                 return jsonify({"error": f"Candidate ID {candidate_ID} not found."}), 404

            update_voter_query = "UPDATE Registered_voters SET has_voted = 'Y' WHERE voter_ID = %s"
            cursor.execute(update_voter_query, (voter_ID,))

        con.commit()

        return jsonify({
            "message": f"Vote successfully recorded for Candidate ID {candidate_ID}."
        }), 200

    except mysql.connector.Error as err:
        con.rollback()
        print(f"Database error during voting: {err}")
        return jsonify({
            "error": "Failed to record vote.",
            "details": str(err)
        }), 500
    except Exception as e:
        con.rollback() 
        print(f"An unexpected error occurred: {e}")
        return jsonify({"error": "An unexpected error occurred", "details": str(e)}), 500

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    if not data or not all(k in data for k in ['username', 'password']):
        return jsonify({"error": "Missing username or password"}), 400
    
    username = data['username']
    password = data['password']

    try:
        if not con.is_connected():
            con.reconnect()
            
        with con.cursor(dictionary=True) as cursor:
            query = "SELECT * FROM Registered_voters WHERE username = %s"
            cursor.execute(query, (username,))
            user = cursor.fetchone()

        if not user:
            return jsonify({"error": "Invalid username or password"}), 401

        stored_hash = user['encrypted_pass']
        if not bcrypt.check_password_hash(stored_hash, password):
            return jsonify({"error": "Invalid username or password"}), 401
            
        access_token = create_access_token(identity=user['voter_ID'])
        
        return jsonify({
            "message": "Login successful.",
            "access_token": access_token,
            "voter_ID": user['voter_ID'],
            "username": user['username'],
            "has_voted": user['has_voted']
        }), 200

    except mysql.connector.Error as err:
        print(f"Database error during login: {err}")
        return jsonify({"error": "Database error", "details": str(err)}), 500
    except Exception as e:
        print(f"An unexpected error occurred during login: {e}")
        return jsonify({"error": "An unexpected server error", "details": str(e)}), 500

if __name__ == "__main__":
    print("Starting Flask application...")
    print("Connecting to the DB....")
    app.run(debug = True)
