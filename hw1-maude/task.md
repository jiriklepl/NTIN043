
Card Payment Terminal
=====================

topic: algebraic specifications in Maude

deadline: 23.11.2020

**task 1**: create algebraic specification of a payment terminal for cards (used in restaurants and shops)

- state: idle, waiting for the card (to be inserted or attached), waiting for the PIN, confirmation, and so on
- support both chip cards and contactless (which are just put close to the reader)
- operations:
  - card validation (not blocked, expiration date)
  - checking account balance (it has to be sufficiently high)
  - updating the account balance after the successful payment
  - retrieving account information from the central database of a respective bank or a card processing organization (VISA, MasterCard)
  - reading user PIN from keyboard (when it is necessary)

**task 2**: document your solution

- explain key decisions and high-level design

**task 3**: prepare some test cases (scenarios, inputs)

- common sequences of actions with a payment terminal
