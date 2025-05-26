#!python
# cython: language_level=3

import os
import argparse
import dotenv
import openai
from termcolor import colored

dotenv.load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

print(colored("Question> ", "cyan"))

def main(q: str):
    try:
        if len(q) > 0:
            statement = q
        else:
            statement = input()
        message = ""
        max_token = 1000
        while statement != "q":
            if statement == "c":
                statement = "please continue, the last context was" + message
                max_token = min(max_token + 1000, 4000)
            elif statement.find("{ctx}"):
                statement = statement.replace("{ctx}", message)
                message = ""
                max_token = min(max_token + 1000, 4000)
            elif len(message) > 0:
                print(colored(message, "light_magenta"))
                print("=====================")
                message = ""
                max_token = 1000

            print(colored(statement, "cyan"))
            for response in openai.Completion.create(
                model="text-davinci-003",
                prompt=statement[:4090],
                temperature=0.6,
                max_tokens=max_token,
                stream=True,
            ):
                # print(response.choices[0].text.strip().replace("\n", ""), end= " ")
                print(
                    colored(response.choices[0].text, "green"),
                    end="",
                    flush=True,
                )
                message += response.choices[0].text
            print()
            print(
                "press (c): read more, \n"
                "put {ctx} if you want to pass current context \n"
                "(q): quit"
            )
            statement = input()
            # message += response.choices[0].text
        print(colored(message, "light_magenta"))
    except Exception as e:
        print(colored(f"fail: {e}", "red"))


def get_arguments():
    parser = argparse.ArgumentParser()
    # +: # of args. [1,n], *: [0,n]
    # dest: name
    parser.add_argument(nargs="*", help="Example) how are you doing?", dest="question")

    question = parser.parse_args().question
    return question


if __name__ == "__main__":
    q = get_arguments()
    nq = " ".join(q)
    main(nq)
