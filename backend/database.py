from pymongo import MongoClient

# Database Configuration
MONGO_URL = "mongodb://localhost:27017/"
DB_NAME = "nearby_pay_db"

client = MongoClient(MONGO_URL)
db = client[DB_NAME]

# Collections
users_collection = db["users"]
transactions_collection = db["transactions"]