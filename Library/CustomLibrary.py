import requests
import random
import string
from datetime import datetime

class CustomLibrary:
    def get_random_customers(self, start=0, limit=5):
        resp = requests.get("https://jsonplaceholder.typicode.com/users", timeout=10)
        resp.raise_for_status()
        customers = resp.json()[start:start+limit] 
        for c in customers:
            c["birthday"] = self.get_random_birthday()
            c["password"] = self.generate_password()
            c["address"]["stateAbbr"] = c["address"]["street"][0] + c["address"]["suite"][0] + c["address"]["city"][0]
        return customers


    def get_random_birthday(self):
        return (
            str(random.randint(1, 12)).zfill(2) +
            str(random.randint(1, 28)).zfill(2) +
            str(random.randint(1999, 2006))
        )

    def format_birthday(self, birthday_str):
        """Accepts 'YYYY-MM-DD' or 'mmddyyyy'; returns 'mmddyyyy'."""
        s = str(birthday_str).strip()
        if "-" in s:
            dt = datetime.strptime(s, "%Y-%m-%d")
            return dt.strftime("%m%d%Y")
        if len(s) == 8 and s.isdigit():
            return s
        raise ValueError(f"Unsupported birthday format: {s}")

    def generate_password(self, length=8):
        chars = string.ascii_letters + string.digits + "!@#$%"
        return "".join(random.choice(chars) for _ in range(length))
