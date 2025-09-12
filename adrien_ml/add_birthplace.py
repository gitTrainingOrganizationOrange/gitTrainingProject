"""Modules for printing names and birthplaces, using name_printer function"""
from adrien_ml.name_printer import print_name

def birthplace_printer(name: str, birthplace: str) -> str:
    """Prints a name and birthplace in a formatted string.

    Args:
        name (str): The name of the person.
        birthplace (str): The birthplace of the person.

    Returns:
        str: A formatted string containing the name and birthplace.
    """
    name_str = print_name(name)
    return f"{name_str} was born in {birthplace}."

if __name__ == "__main__":
    # Example usage
    print(birthplace_printer("Adrien", "Paris"))

