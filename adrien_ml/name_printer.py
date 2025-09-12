"""Modules for printing names."""

def print_name(name: str) -> str:
    """
        Prints the given name.
        Args:
            name (str): The name to print.
            
        Returns:
            str: The printed name.
    """
    print(f"Name: {name}")
    return name

def print_birthplace(name: str, birthplace: str) -> str:
    """
        Prints the given name and birthplace.
        Args:
            name (str): The name to print.
            birthplace (str): The birthplace to print.
            
        Returns:
            str: The printed name and birthplace.
    """
    print(f"{name} was born in {birthplace}.")
    return f"{name} was born in {birthplace}."

if __name__ == "__main__":
    print_birthplace("Adrien", "Paris")
