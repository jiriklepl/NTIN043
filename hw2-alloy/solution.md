# Alloy: smart home

## Assignment

topic: models in Alloy

deadline: 31.12.2020

**task 1**: create model for "smart home"

- important aspects: sensors, control, security, other equipment
- you have to decide what entities and operations to define
- do not forget to define some assertions and commands (run, check)

**task 2**: document your solution

- explain key design decisions and more advanced usage of Alloy

note: you can define the model in Alloy

## Solution

Řešení (používající Alloy) bylo rozděleno do dvou souborů: [smartHome.als](smartHome.als) a [smartHomeCore.als](smartHomeCore.als).

*smartHomeCore.als* má za cíl simulovat nějakou obecnou knihovnu pro více chytrých domácností, *smartHome.als* je pak implementace pro konkrétní domácnost.

### Inspiration

- [HomeKit](https://developer.apple.com/documentation/homekit)

Řešení úkolu bylo inspirováno reálným řešením software pro chytrou domácnost, neboť já sám nemám žádné tušení, jak chytré domácnosti mají fungovat.

### SmartHomeCore

SmartHomeCore používá signatury se sémantikou rekordů s výjimkou těch, které mají v názvu `Type` či `Category`, takové jsou používány jako simulace enumerací.

Definice signatur jsou často doprovázeny definicemi `fact`. Jejich význam je slovně vysvětlen v souboru v komentářích těsně nad těmito definicemi (kromě definic jednotlivých typů a kategorií, které jsou nezajímavé a převážně zjevné).

### smartHome

SmartHome definuje chytrou domácnost se čtyřmi pokoji. V každém pokoji požadujeme přítomnost alespoň dvou zásuvek, okna a žárovky. V celé domácnosti pak musí být právě jeden alarm a větrák a dohromady se v domácnosti nacházi maximálně dvacet chytrých zařízení (například z ekonomických důvodů).

### Spuštění

Ve složce je [Makefile](Makefile), který by měl spustit řešení v analyzéru Alloy, pokud se tak nestane, na systému se nejspíše nenachází java, nebo je přítomná verze javy nekompatibilní.
