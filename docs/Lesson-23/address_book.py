contacts = {}

next_id = 1


def add_contact():
    global next_id

    print("\n=== Dodawanie kontaktu ===")

    name = input("Imię: ")
    surname = input("Nazwisko: ")

    while True:
        phone = input("Telefon: ")

        if phone.isdigit():
            break
        else:
            print("Numer telefonu musi składać się tylko z cyfr!")

    email = input("Email: ")

    contacts[next_id] = {
        "imie": name,
        "nazwisko": surname,
        "telefon": phone,
        "email": email
    }

    print(f"Kontakt dodany. ID kontaktu: {next_id}")

    next_id += 1


def show_contacts():
    print("\n=== Wszystkie kontakty ===")

    if not contacts:
        print("Brak kontaktów.")
        return

    for contact_id, contact in contacts.items():
        print("--------------------")
        print(f"ID: {contact_id}")
        print(f"Imię: {contact['imie']}")
        print(f"Nazwisko: {contact['nazwisko']}")
        print(f"Telefon: {contact['telefon']}")
        print(f"Email: {contact['email']}")


def search_contact():
    print("\n=== Wyszukiwanie ===")

    search = input("Podaj imię lub nazwisko: ").lower()

    found = False

    for contact_id, contact in contacts.items():

        if (
            search in contact["imie"].lower()
            or search in contact["nazwisko"].lower()
        ):
            print("--------------------")
            print(f"ID: {contact_id}")
            print(
                f"{contact['imie']} "
                f"{contact['nazwisko']}"
            )
            print(f"Telefon: {contact['telefon']}")
            print(f"Email: {contact['email']}")

            found = True

    if not found:
        print("Nie znaleziono kontaktu.")


def delete_contact():
    print("\n=== Usuwanie kontaktu ===")

    try:
        contact_id = int(input("Podaj ID kontaktu: "))

        if contact_id in contacts:
            del contacts[contact_id]
            print("Kontakt został usunięty.")
        else:
            print("Nie ma kontaktu o takim ID.")

    except ValueError:
        print("ID musi być liczbą!")


def edit_contact():
    print("\n=== Edycja kontaktu ===")

    try:
        contact_id = int(input("Podaj ID kontaktu: "))

        if contact_id not in contacts:
            print("Nie znaleziono kontaktu.")
            return

        contact = contacts[contact_id]

        print("Zostaw puste pole aby nie zmieniać wartości.")

        name = input(
            f"Imię ({contact['imie']}): "
        )

        surname = input(
            f"Nazwisko ({contact['nazwisko']}): "
        )

        phone = input(
            f"Telefon ({contact['telefon']}): "
        )

        email = input(
            f"Email ({contact['email']}): "
        )

        if name:
            contact["imie"] = name

        if surname:
            contact["nazwisko"] = surname

        if phone:
            if phone.isdigit():
                contact["telefon"] = phone
            else:
                print("Telefon nie został zmieniony - zły format.")

        if email:
            contact["email"] = email


        print("Kontakt został zaktualizowany.")

    except ValueError:
        print("ID musi być liczbą!")


def menu():

    while True:

        print("""
========================
     KSIĄŻKA ADRESOWA
========================

1. Dodaj kontakt
2. Wyświetl kontakty
3. Wyszukaj kontakt
4. Usuń kontakt
5. Edytuj kontakt
6. Wyjście
""")

        choice = input("Wybierz opcję: ")

        if choice == "1":
            add_contact()

        elif choice == "2":
            show_contacts()

        elif choice == "3":
            search_contact()

        elif choice == "4":
            delete_contact()

        elif choice == "5":
            edit_contact()

        elif choice == "6":
            print("Koniec programu.")
            break

        else:
            print("Niepoprawna opcja.")


if __name__ == "__main__":
    menu()