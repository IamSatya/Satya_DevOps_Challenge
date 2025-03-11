import requests

class PaginatedAPIClient:
    def __init__(self, base_url, endpoint, params=None):
        self.base_url = base_url
        self.endpoint = endpoint
        self.params = params or {}

    def get_all_data(self):
        all_data = []
        current_page = 1
        while True:
            response = requests.get(f"{self.base_url}/{self.endpoint}", params={**self.params, "page": current_page})
            response.raise_for_status()  # Raise an exception if the request fails
            data = response.json()
            all_data.extend(data["results"])  # Assuming data is in "results" key
            if len(data["results"]) < self.params.get("per_page", 10):  # Check if last page reached
                break
            current_page += 1
        return all_data

# Example usage
api_client = PaginatedAPIClient("https://api.example.com", "users", {"per_page": 20}) 
all_users = api_client.get_all_data()

print(all_users)
