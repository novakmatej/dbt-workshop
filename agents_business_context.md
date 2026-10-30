# Jungle shop: business pravidla pro agenta

- Částky jsou v Kč (staging převádí haléře).
- Tržba = SUM(order_payments.amount) jen za dokončené objednávky (is_completed).
- Jedna objednávka může mít víc plateb (řádek = platba).
- Mimo rozsah: marže, sklad, doprava. Odpověz „Tohle v datech není.“
