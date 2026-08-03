import string
from collections import Counter


def text_analysis(text):

    characters_with_spaces = len(text)
    characters_without_spaces = len(text.replace(" ", ""))


    cleaned_text = text.lower().translate(
        str.maketrans("", "", string.punctuation)
    )


    words = cleaned_text.split()


    word_count = len(words)


    sentence_count = (
        text.count(".") +
        text.count("!") +
        text.count("?")
    )


    if words:
        longest_word = max(words, key=len)
    else:
        longest_word = "Brak"


    if words:
        counter = Counter(words)
        max_count = max(counter.values())

        most_common_words = [
            word for word, count in counter.items()
            if count == max_count
        ]
    else:
        most_common_words = []
        max_count = 0


    print("\n===== STATYSTYKI TEKSTU =====")
    print(f"Liczba znaków (ze spacjami): {characters_with_spaces}")
    print(f"Liczba znaków (bez spacji): {characters_without_spaces}")
    print(f"Liczba słów: {word_count}")
    print(f"Liczba zdań: {sentence_count}")
    print(f"Najdłuższe słowo: {longest_word}")

    if most_common_words:
        print(
            f"Najczęściej występujące słowo(a): "
            f"{', '.join(most_common_words)} "
            f"(wystąpiło {max_count} razy)"
        )
    else:
        print("Najczęściej występujące słowo(a): Brak")


def main():
    text = input("Podaj tekst: ")
    text_analysis(text)


if __name__ == "__main__":
    main()