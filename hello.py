from flask import Flask

# Initialize the Flask application
app = Flask(__name__)

# Define the route for the home page
@app.route("/")
def hello():
    return "Hello, World!"

if __name__ == "__main__":
    # Run the server on port 8000
    app.run(port=8000,host="0.0.0.0", debug=True)
    
print("helloe world")
