import json

def store_data(data, filename="data.json"):
    """
    Stores user input data in a JSON file.
    """
    with open(filename, "w") as file:
        json.dump(data, file)

def retrieve_data(filename="data.json"):
    """
    Retrieves stored data from a JSON file.
    """
    try:
        with open(filename, "r") as file:
            return json.load(file)
    except FileNotFoundError:
        return {}

def main():
    """
    CLI interface for storing and retrieving data.
    """
    data = retrieve_data()
    
    while True:
        action = input("Enter action (add, get, exit): ")
        if action == "add":
            key = input("Enter key: ")
            value = input("Enter value: ")
            data[key] = value
            store_data(data)
            print("Data added successfully!")
        elif action == "get":
            key = input("Enter key to retrieve: ")
            if key in data:
                print(data[key])
            else:
                print("Key not found!")
        elif action == "exit":
            break
        else:
            print("Invalid action. Please choose 'add', 'get', or 'exit'.")

if __name__ == "__main__":
    main()
