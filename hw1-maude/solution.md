# Card Payment Terminal

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

## Solution

Řešení bylo rozděleno do tří souborů: [terminal.maude](terminal.maude), [bank.maude](bank.maude) a [world.maude](world.maude).

Jednotlivé aktivní interakce s terminálem jsou dány následujícími funkcemi:

```maude
--- 1.
op requestPayment : Price Terminal -> Terminal .

--- 2.
ops attachCard swipeCard insertCard removeCard : Card Terminal -> Terminal .

--- 3.
op providePIN : CardPIN Terminal -> Terminal .

--- 4.
op transaction : Terminal World -> TransactionResult .

--- 5.
op removeCard : Terminal -> Transaction .
```

1. vezme terminál ve stavu `idle`, uloží do něj požadovanou částku, a převede ho do stavu `waitingForCard`
2. vezme terminál ve stavu `waitingForCard` a podle použité činnosti (přejetí, přiložení, vložení) buďto přejde do stavu `waitingForPIN`, nebo v případě bezkontaktní platby do 500 Kč přejde rovnou do stavu `waitingForFastTransaction`, vše za uložení čísla karty a její banky
3. vezme terminál ve stavu `waitingForPIN` a po přijetí maximálně šestimístného PIN přejde do stavu `waitingForTransaction`
4. vezme terminál ve stavu `waitingForTransaction` nebo `waitingForTransaction` a svět a vrátí objekt reprezentující tuto dvojici po provedení transakce; ve stavu terminálu jsou uloženy všechny případné chyby (podle specifikace a některé další), proč se nezdařilo provést transakci (to obnáší nalezení obou bank, účtů na nich a výměny částek mezi účty, je-li na zdrojovém dostatečná částka); toto reprezentuje moment kdy zákazník vytí výsledek na terminálu; pro získáni terminálu je nutno výsledek dát jakožto parametr pro `getTerminal`, jež jej uvede do `idle` stavu a vymaže dočasná data z jeho paměti; pro získání světa zase `getWorld`
5. `removeCard` reprezentuje vyjmutí karty z terminálu po provedení platby

### Terminal

```maude
op terminal : TerminalState TerminalMemory Card -> Terminal .
op terminalMemory : Price AccountNumber BankName Card CardPIN -> TerminalMemory .
```

Obsahuje definice samotného terminálu, terminál si pamatuje cílový protiúčet (své firmy) a banku, na níž je vytvořen, v dočasné paměti pak má klientovu karu a její PIN, do terminálu může být zasunuta karta, jež pak musí být vysunuta.

### World

```maude
op world : Date WorldBanks -> World .

op worldBanks : Bank WorldBanks -> WorldBanks .
op worldBanks : -> WorldBanks .
```

Svět si pamatuje dnešní datum a seznam existujících bank. Jeho úkolem je koordinovat všechno dění mezi terminály a zbytkem světa (je připraven i na snadnou implementaci situace *účet vs účet*).

### Bank

```maude
op bank : BankName BankAccounts BankCards -> Bank .

op bankAccounts : Account BankAccounts -> BankAccounts .
op bankAccounts : -> BankAccounts .

op bankCards : CardNumber CardPIN CardIsBlocked CardExpDate AccountNumber BankCards -> BankCards .
op bankCards : -> BankCards .

op account : AccountNumber Balance -> Account .
op card : CardNumber BankName -> Card .
```

Banka má jméno, potom vlastní určitý seznam karetních dat, kde zná jejich PIN, blokaci a datum expirace a přiřazený účet. Dále má banka seznam účtů, které mají každý nějakou bilanci.

Tato architektura dovoluje, aby k jednomu účtu byly přiřazeny různé karty.

Karta má na sobě vytištěné své číslo a banku ke které patří.

### Testing

K řešení je připojen jeden testovací soubor reprezentující možné použití řešení.

Následující příkazy po načtení `maude test.maude` (vizte tento sour pro podrobnější informace, co se skrývá za danými příkazy ) by měly vytisknout očekávané výsledky podle výše zmíněných informací:

```maude
rew dummyWorld .
rew dummyCard .
rew dummyTerminal .
rew dummyPayment . --- requestPayment
rew dummyReceivedCard . --- attachCard
rew dummyProvidedPIN . --- providePIN
rew dummyTransaction . --- transaction
rew getTerminal(dummyTransaction) .
rew getWorld(dummyTransaction) .
```
