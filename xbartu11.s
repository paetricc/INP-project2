; Vernamova sifra na architekture DLX
; Tomas Bartu xbartu11

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xbartu11"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	addi r1, r0, 0		; counter
	lb r11, login+1(r0)
	lb r17, login+2(r0)
	subi r11, r11, 96	; o kolik pujdeme do plusu
	subi r17, r17, 96	; o kolik pujdu do minusu

for:
	;------ pricitani -------
	lb r19, login(r1)
	slei r22, r19, 96	; if(r22<='`') isNumber();
	bnez r22, isNumber
	nop
	nop
	
	add r19, r19, r11	; pricteme hodnotu => zasifrovane
	slei r22, r19, 122	; if('zasifrovanyChar' <= 'z') tak ukonci if 
	bnez r22, endif1	
	nop
	nop
	; korekce pretekle abecedy
	subi r19, r19, 122
	addi r19, r19, 96

    endif1:
	sb cipher(r1), r19	; upravenou hodnotu vlozime zpet na pozici
	addi r1, r1, 1		; zinkrementujeme counter
	; ----- konec pricitani -----

	; ----- odecet -----
	lb r19, login(r1)
	slei r22, r19, 96	; if(r22<='`') isNumber();
	bnez r22, isNumber
	nop
	nop
	
	sub r19, r19, r17	; pricteme hodnotu => zasifrovane
	sgei r22, r19, 97	; if('zasifrovanyChar' >= 'a') tak ukonci if 
	bnez r22, endif2
	nop
	nop
	; korekce pretekle abecedy
	addi r22, r0, 96
	sub r19, r22, r19
	addi r22, r0, 122
	sub r19, r22, r19

    endif2:
	sb cipher(r1), r19
	addi r1, r1, 1
	; ----- konec odecet -----
	j for
	nop
	nop
	; ----- konec cyklu -----

isNumber:
	sb cipher(r1), r0
	
end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
