# GrowHub

## Autorzy
Szymon Pawłowski, Jakub Mądry, Franciszek Zarębski  

---

## 📌 Opis projektu
**GrowHub** to system do monitorowania i automatyzacji upraw hydroponicznych. Nasza aplikacja mobilna oraz backend umożliwiają użytkownikowi pełną kontrolę nad parametrami takimi jak:
- **pH** wody
- **Przewodność elektryczna (TDS)**
- **Temperatura wody**

System monitoruje parametry wody co **10 minut**, zapisuje dane historyczne i wysyła powiadomienia, jeśli wartości przekroczą ustalone progi. Dodatkowo mikrokontroler automatycznie koryguje poziom składników odżywczych w wodzie.

## 🎯 Główne cele projektu
✅ Automatyzacja procesu kontroli parametrów upraw hydroponicznych  
✅ Monitorowanie stanu wody w czasie rzeczywistym  
✅ Usprawnienie wydajności i optymalizacja wzrostu roślin  
✅ Powiadomienia użytkownika w przypadku przekroczenia progów alarmowych  
✅ Integracja z aplikacją mobilną

## 🏗️ Architektura systemu

GrowHub jest systemem **modularnym i skalowalnym**, składającym się z kilku głównych komponentów:

1. **Backend** - API obsługujące żądania urządzeń oraz aplikacji mobilnej
2. **Hardware** - mikrokontroler ESP do pomiarów i automatycznej regulacji
3. **Mobile** - aplikacja mobilna do zarządzania systemem

### 📊 Schemat architektury systemu
```
[Urządzenia pomiarowe] -> [Mikrokontroler ESP] -> [Serwer API] -> [Aplikacja Mobilna]
```

![Schemat architektury](docs/architecture.png)

## 🔧 Technologie
Projekt wykorzystuje następujące technologie:

### Backend:
- Node.js / Express.js
- Baza danych PostgreSQL
- MQTT do komunikacji IoT

### Hardware:
- Mikrokontroler ESP32
- Czujniki pH, TDS, temperatury
- Moduł dozowania nawozów

### Mobile:
- React Native
- Firebase Authentication

## 🚀 Ścieżka wdrożenia
1. **Konfiguracja backendu** - uruchomienie API i bazy danych
2. **Podłączenie mikrokontrolera ESP** - konfiguracja czujników i przesyłania danych
3. **Instalacja aplikacji mobilnej** - sparowanie urządzenia z kontem użytkownika

## 🛠️ Testy
System przeszedł testy:
- Integracyjne
- Funkcjonalne
- Obciążeniowe dla backendu

## 🎬 Demonstracja
Wideo demo działania systemu: ![Aplikacja mobilna](docs/demo.png)

## 📖 Dokumentacja API
Szczegółowa dokumentacja API dostępna pod adresem: 
📄 [Dokumentacja API](docs/api_documentation.md)

## 📌 Czego się nauczyliśmy?
- Efektywnej komunikacji między backendem a urządzeniami IoT
- Integracji systemu z aplikacją mobilną
- Optymalizacji algorytmów dozowania składników odżywczych

## 📌 Co można było zrobić lepiej?
- Ulepszenie interfejsu użytkownika aplikacji mobilnej
- Optymalizacja zarządzania danymi historycznymi
- Wsparcie dla większej liczby typów czujników

## 🎉 Podziękowania
Dziękujemy za zainteresowanie naszym projektem! 😊
