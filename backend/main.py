import os
import base64
from datetime import datetime
from typing import List, Optional
from fastapi import FastAPI, HTTPException, Body, Depends
from fastapi.middleware.cors import CORSMiddleware
from database import db # Uses the database.py file
from pydantic import BaseModel
# CHANGED: Switched to Werkzeug for stable hashing
from werkzeug.security import generate_password_hash, check_password_hash
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

app = FastAPI()

# --- CONFIG ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- SECURITY (AES-128 E2EE) ---
SHARED_SECRET_KEY = b'1234567890123456' 

def decrypt_data(encrypted_b64: str) -> str:
    try:
        data_bytes = base64.b64decode(encrypted_b64)
        iv = data_bytes[:16]
        ct = data_bytes[16:]
        cipher = AES.new(SHARED_SECRET_KEY, AES.MODE_CBC, iv)
        pt = unpad(cipher.decrypt(ct), AES.block_size)
        return pt.decode('utf-8')
    except Exception as e:
        print(f"Decryption Error: {e}")
        return None

# --- MODELS ---
class UserAuth(BaseModel):
    name: str
    phone: str
    pin: str

class TransactionReq(BaseModel):
    sender_phone: str
    receiver_phone: str
    encrypted_amount: str
    note: Optional[str] = None

# --- ROUTES ---

@app.post("/auth/register")
def register(user: UserAuth):
    if db.users.find_one({"phone": user.phone}):
        raise HTTPException(status_code=400, detail="Phone already registered")
    
    # CHANGED: Use generate_password_hash
    hashed_pin = generate_password_hash(user.pin)
    
    new_user = {
        "name": user.name,
        "phone": user.phone,
        "pin_hash": hashed_pin,
        "balance": 100000.0,
        "created_at": datetime.now()
    }
    db.users.insert_one(new_user)
    return {"status": "success", "message": "Account created", "balance": 100000.0}

@app.post("/auth/login")
def login(phone: str = Body(..., embed=True), pin: str = Body(..., embed=True)):
    user = db.users.find_one({"phone": phone})
    
    # CHANGED: Use check_password_hash
    if not user or not check_password_hash(user['pin_hash'], pin):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    return {
        "status": "success",
        "user": {
            "name": user['name'],
            "phone": user['phone'],
            "balance": user['balance']
        }
    }

@app.get("/user/nearby")
def get_nearby_simulation(exclude_phone: str):
    users = list(db.users.find({"phone": {"$ne": exclude_phone}}, {"_id": 0, "pin_hash": 0, "balance": 0}))
    return users

@app.post("/wallet/transact")
def process_transaction(req: TransactionReq):
    decrypted_amount_str = decrypt_data(req.encrypted_amount)
    
    if not decrypted_amount_str:
        raise HTTPException(status_code=400, detail="Security Verification Failed")
    
    amount = float(decrypted_amount_str)
    
    sender = db.users.find_one({"phone": req.sender_phone})
    receiver = db.users.find_one({"phone": req.receiver_phone})
    
    if not sender or not receiver:
        raise HTTPException(status_code=404, detail="User not found")
    
    if sender['balance'] < amount:
        raise HTTPException(status_code=400, detail="Insufficient funds")
    
    db.users.update_one({"phone": req.sender_phone}, {"$inc": {"balance": -amount}})
    db.users.update_one({"phone": req.receiver_phone}, {"$inc": {"balance": amount}})
    
    tx = {
        "sender": req.sender_phone,
        "receiver": req.receiver_phone,
        "sender_name": sender['name'],
        "receiver_name": receiver['name'],
        "amount": amount,
        "note": req.note,
        "timestamp": datetime.now(),
        "type": "proximity_transfer"
    }
    db.transactions.insert_one(tx)
    
    return {"status": "success", "new_balance": sender['balance'] - amount}

@app.get("/wallet/history/{phone}")
def get_history(phone: str):
    txs = list(db.transactions.find({
        "$or": [{"sender": phone}, {"receiver": phone}]
    }).sort("timestamp", -1))
    for t in txs: t['_id'] = str(t['_id'])
    return txs