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

if __name__ == "__main__":
    print_name("Adrien")
