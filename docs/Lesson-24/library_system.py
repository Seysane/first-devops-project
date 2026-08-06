class Book:
    def __init__(self, title, author, isbn, publication_year):
        self.title = title
        self.author = author
        self.isbn = isbn
        self.publication_year = publication_year
        self.available = True

    def __str__(self):
        status = "Available" if self.available else "Borrowed"
        return (
            f"{self.title} - {self.author} "
            f"({self.publication_year}) | ISBN: {self.isbn} | {status}"
        )


class Reader:
    def __init__(self, first_name, last_name, reader_id):
        self.first_name = first_name
        self.last_name = last_name
        self.reader_id = reader_id
        self.borrowed_books = []

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.reader_id})"


class Library:
    def __init__(self, name, address):
        self.name = name
        self.address = address

        # Encapsulation
        self.__books = []
        self.__readers = []

    # Add a new book
    def add_book(self, book):
        self.__books.append(book)

    # Register a new reader
    def register_reader(self, reader):
        self.__readers.append(reader)

    # Remove a book
    def remove_book(self, isbn):
        book = self.search_by_isbn(isbn)

        if book:
            self.__books.remove(book)
            print("Book removed successfully.")
        else:
            print("Book not found.")

    # Search by ISBN
    def search_by_isbn(self, isbn):
        for book in self.__books:
            if book.isbn == isbn:
                return book
        return None

    # Search by title
    def search_by_title(self, title):
        return [
            book
            for book in self.__books
            if title.lower() in book.title.lower()
        ]

    # Search by author
    def search_by_author(self, author):
        return [
            book
            for book in self.__books
            if author.lower() in book.author.lower()
        ]

    # Borrow a book
    def borrow_book(self, reader_id, isbn):
        reader = next(
            (r for r in self.__readers if r.reader_id == reader_id),
            None,
        )

        book = self.search_by_isbn(isbn)

        if reader is None:
            print("Reader not found.")
            return

        if book is None:
            print("Book not found.")
            return

        if not book.available:
            print("Book is already borrowed.")
            return

        book.available = False
        reader.borrowed_books.append(book)

        print(f"{reader.first_name} borrowed '{book.title}'.")

    # Return a book
    def return_book(self, reader_id, isbn):
        reader = next(
            (r for r in self.__readers if r.reader_id == reader_id),
            None,
        )

        if reader is None:
            print("Reader not found.")
            return

        for book in reader.borrowed_books:
            if book.isbn == isbn:
                reader.borrowed_books.remove(book)
                book.available = True
                print(f"'{book.title}' returned successfully.")
                return

        print("Reader does not have this book.")

    # Display reader status
    def reader_status(self, reader_id):
        reader = next(
            (r for r in self.__readers if r.reader_id == reader_id),
            None,
        )

        if reader is None:
            print("Reader not found.")
            return

        print(f"\nReader: {reader}")

        if not reader.borrowed_books:
            print("No borrowed books.")
            return

        for book in reader.borrowed_books:
            print("-", book)


# ==========================
# Testing
# ==========================

library = Library("City Library", "Warsaw")

book1 = Book(
    "Python Basics",
    "John Smith",
    "111",
    2022,
)

book2 = Book(
    "Docker in Practice",
    "Adam Brown",
    "222",
    2023,
)

book3 = Book(
    "Terraform Essentials",
    "Anna White",
    "333",
    2024,
)

library.add_book(book1)
library.add_book(book2)
library.add_book(book3)

reader1 = Reader("Sebastian", "Sicinski", "R001")
reader2 = Reader("Anna", "Nowak", "R002")

library.register_reader(reader1)
library.register_reader(reader2)

library.borrow_book("R001", "111")
library.borrow_book("R001", "222")

library.reader_status("R001")

library.return_book("R001", "111")

library.reader_status("R001")

print("\nBooks written by Adam:")

for book in library.search_by_author("Adam"):
    print(book)