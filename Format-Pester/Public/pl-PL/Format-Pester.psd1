#Please read the section 'Information for translators' on the GitHub project page
#Read also Get-Help about_Script_Internationalization

#The language pl-PL file prepared by Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
#String aligned to version - see the value of msgA000

#Translate values, don't touch 'msgxxxx' fields !

# Groups of translation strings
# A = general
# X - temporary deprecation messages
# B = passed tests
# C = failed tests
# D = skipped tests
# E = pending tests
# F = inconclusive tests

# culture="pl-PL"
ConvertFrom-StringData @'
    msgA000=1.5.0
    msgA001=Spis treści
    msgA002=Testy ogółem
    msgA003=Testy zdane
    msgA004=Testy niezdane
    msgA005=Testy pominięte
    msgA006=Testy trwające
    msgA007=Nierozstrzygnięte
    msgA008=Podsumowanie wyników testów
    msgA009=Przetwarzanie rezultatów testów dla
    msgA010=Describe
    msgA011=Context
    msgA012=Nazwa
    msgA013=Język
    msgA014=nie jest wspierany. Będzie użyty język domyślny tj. en-US.
    msgA015=Wersja pliku języka jest inna niż wersja funkcji Format-Pester.ps1. Niektóre teksty mogą być wyświetlane niepoprawnie.
    msgA016=Wykonywanie operacji dla
    msgA017=liczba rezultatów
    #Type of encoding used for write text files
    #Suppurted vales: ASCII,Unicode,UTF7,UTF8
    msgA018=UTF8
    msgA019 = Wartość parametru PesterResult nie może być pusta.
    msgA020 = Nazwa wyniku testu: '{0}' jest powielona w wartości parametru ResultOrder. Duplikat zostanie pominięty by uniknąć powielenia sekcji dokumentu.
    msgA021 = Nazwa wyniku testu: '{0}' jest nierozpoznana i nie zostanie uwzględniona w dokumencie. Muszą zostać użyte angielskie nazwy wyników testów.
    msgA022 = Dokumenty zostaną wyeksportowane przy użyciu ustawień:
    msgX001 = Użycie parametru '{0}' jest niepożądane gdyż zostanie on usunięty w przyszłej wersji Format-Pester. Proszę użyć parametru Include.
    msgX002 = Użycie parametru Order jest niepożądane gdyż zostanie on usunięty w przyszłej wersji Format-Pester. Proszę użyć parametru ResultOrder.
    msgX003 = Został użyty parametr PassedFirst ale rezultaty zdanych testów nie są ujęte w raporcie.
    msgX004 = Został użyty parametr FailedFirst ale rezultaty niezdanych testów nie są ujęte w raporcie.
    msgB000=Zdane
    msgB001=Szczegóły zdanych testów
    msgB002=Szczegóły zdanych testów dla bloku Describe:
    msgB003=Szczegóły zdanych testów dla bloku Context:
    msgB004=Znaleziono zdane testy dla bloku Describe
    msgB005=Znaleziono zdane testy dla bloku Context
    msgB006=NOT_EXISTS
    msgB007=Zdane testy
    msgC000=Niezdane
    msgC001=Szczegóły niezdanych testów
    msgC002=Szczegóły niezdanych testów dla bloku Describe:
    msgC003=Szczegóły niezdanych testów dla bloku Context:
    msgC004=Znaleziono zdane testy dla bloku Describe
    msgC005=Znaleziono zdane testy dla bloku Context
    msgC006=Komunikat niezdanego testu
    msgC007=Niezdane testy
    msgD000=Pominięte
    msgD001=Szczegóły pominiętych testów
    msgD002=Szczegóły pominiętych testów dla bloku Describe:
    msgD003=Szczegóły pominiętych testów dla bloku Context:
    msgD004=Znaleziono pominięte testy dla bloku Describe
    msgD005=Znaleziono pominięte testy dla bloku Context
    msgD006=Komunikat pominiętego testu
    msgD007=Pominięte testy
    msgE000=Trwające
    msgE001=Szczegóły trwających testów
    msgE002=Szczegóły trwających testów dla bloku Describe:
    msgE003=Szczegóły trwających testów dla bloku Context:
    msgE004=Znaleziono trwające testy dla bloku Describe
    msgE005=Znaleziono trwające testy dla bloku Context
    msgE006=Komunikat trwającego testu
    msgE007=Trwające testy
    msgF000=Nierozstrzygnięte
    msgF001=Szczegóły nierozstrzygniętych testów
    msgF002=Szczegóły nierozstrzygniętych testów dla bloku Describe:
    msgF003=Szczegóły nierozstrzygniętych testów dla bloku Context:
    msgF004=Znaleziono nierozstrzygnięte testy dla bloku Describe
    msgF005=Znaleziono nierozstrzygnięte testy dla bloku Context
    msgF006=Komunikat nierozstrzygniętego testu
    msgF007=Nierozstrzygnięte testy
'@
